{ config, ... }:
{
  environment.persistence."/persistent".directories = [
    {
      directory = "/var/lib/clamav";
      user = "clamav";
      group = "clamav";
      # mode =
    }
  ];
}
