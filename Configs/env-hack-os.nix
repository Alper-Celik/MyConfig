{ config, ... }:
{
  environment.sessionVariables = config.environment.variables;
}
