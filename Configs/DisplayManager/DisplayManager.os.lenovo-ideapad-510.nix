{ inputs, lib, config, pkgs, ... }: {
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${
      pkgs.writeText "gdm-monitors.xml" ''

        <monitors version="2">
          <configuration>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-1</connector>
                  <vendor>SAM</vendor>
                  <product>SyncMaster</product>
                  <serial>HMDSB05010</serial>
                </monitorspec>
                <mode>
                  <width>1440</width>
                  <height>900</height>
                  <rate>74.984428405761719</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
          <configuration>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-1</connector>
                  <vendor>SAM</vendor>
                  <product>SyncMaster</product>
                  <serial>HMDSB05010</serial>
                </monitorspec>
                <mode>
                  <width>1440</width>
                  <height>900</height>
                  <rate>74.984428405761719</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <disabled>
              <monitorspec>
                <connector>eDP-1</connector>
                <vendor>BOE</vendor>
                <product>0x065e</product>
                <serial>0x00000000</serial>
              </monitorspec>
            </disabled>
          </configuration>
        </monitors>
      ''
    }"
  ];
}
