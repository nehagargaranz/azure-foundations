# Azure Cloud Foundations

![Azure](docs/images/azure-logo.svg)

Azure Cloud Foundations provides the baseline security, networking, and operational capabilities required for a successful cloud journey. It comprises pre-built, easily extensible Infrastructure as Code, ensuring a flexible and robust Cloud environment that can be customised as needed.

See the [architecture](docs/architecture.md) documentation for more detailed information.

## Repository Structure

The repository is split into two main folders:

* `modules/` - Composable [Terraform](https://www.terraform.io/) modules that perform the platform configuration
* `environments/` - Composition and configuration of the modules by [Terragrunt](https://terragrunt.gruntwork.io/); this is where we define each environment, and tie modules together through dependencies in `terragrunt.hcl` files

Configuration of each module is provided by YAML configuration files that are placed at each level within the `environments/` folder structure; where configuration deeper in the structure has a higher precedence. This is configured by the root `terragrunt.hcl` file. These files can be don't need to be named as such, and multiple files can exist at the same level:

* `common.yaml` contains the root level / default configuration
* `environment.yaml` applies configuration to an entire environment
* `location.yaml` applies configuration to an entire location
* `module.yaml` module specific configuration

Additional files:

* `.editorconfig` maintains consistent coding style
* `.terraform-version` & `.terragrunt-version` are used by `tfenv` and `tgenv` respectively to pin versions
* `.tflint.hcl` configures the tflint rules
* `Makefile` abstracts common command-line calls
* `.devcontainer` contains the containerised development environment for Visual Studio Code

## Deployment

See the [bootstrapping](docs/bootstrap.md) documentation for instructions on how to deploy Azure Cloud Foundations.

All tooling is run within a docker container by default using [Visual Studio Code Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers). Please ensure you have this plugin installed, and that you're logged into the container registry prior to opening the project.

For information on planning and applying changes using the Makefile and its targets, run `make help`.

## Contributing

See the [contributing](docs/contributing.md) documentation on how to contribute changes to this repository.

## Troubleshooting

See the [troubleshooting](docs/troubleshooting.md) documentation on how to troubleshoot issues with this repository.
