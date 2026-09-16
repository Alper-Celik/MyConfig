{
  lib,
  config,
  ...
}:
# ai generated
# Workstation alloy, mirrors MyServers' common/grafana-alloy/default.nix —
# but unconditional: servers keep enable=false-able because hosts opt in via
# their own grafana-alloy.nix; here the module's whole purpose is enabling it.
{

  services.alloy = {
    enable = true;
    configPath = "${./workstation.alloy}";
  };

  users = {
    users.alloy = {
      isSystemUser = true;
      group = "alloy";
      extraGroups = [
        "messagebus"

        # for journal see https://grafana.com/docs/alloy/latest/reference/components/loki/loki.source.journal/
        "adm"
        "systemd-journal"
      ]
      ++ (lib.optionals config.services.nginx.enable [ "nginx" ]);
    };
    groups.alloy = { };
  };

  systemd.services.alloy.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "alloy";
    Group = "alloy";
  };

  # Default OTLP export settings for every systemd unit on this host.
  # Apps with an OTel SDK pick these up automatically; others ignore them.
  # host/arch attribution happens in Alloy (otelcol.alloy relabels), so no
  # OTEL_RESOURCE_ATTRIBUTES needed here.
  systemd.settings.Manager = {
    DefaultEnvironment = [
      "OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318"
      "OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf"
    ];

  };
}
