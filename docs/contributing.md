# Contributing

## Prerequisites
Before you continue, please ensure you have met the following requirements:

### Tools

**Containerised Development Environment:**

*Use a preconfigured docker container as the development environment to provide consistency of tooling across developers, and automation pipelines.*

* [Visual Studio Code](https://code.visualstudio.com/)
  * [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) Visual Studio CodeExtension
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) for authenticating to Azure
* [Git](https://git-scm.com/) is installed, and you are familiar with its use
* [Docker Desktop](https://www.docker.com/products/docker-desktop)

You will need to authenticate to the docker host where the devcontainer exists prior to opening in Visual Studio Code:
```shell
docker login docker.servian.com
```

**Native Development Environment:**

*Run all software locally on the development machine.*

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) for authenticating to Azure
* [Git](https://git-scm.com/) is installed, and you are familiar with its use
* [GNU Make](https://www.gnu.org/software/make/) to utilise the Makefile helper targets
* [EditorConfig](https://editorconfig.org/) or an equivalent IDE plugin
* [tfenv](https://github.com/tfutils/tfenv) and [tgenv](https://github.com/cunymatthieu/tgenv) version managers
* [tflint](https://github.com/terraform-linters/tflint) Terraform linter
* [terraform-docs](https://github.com/segmentio/terraform-docs)* Module documentation generator
* [yamllint](https://github.com/adrienverge/yamllint) YAML linter

*Note: These tools are installed inside the included docker image; but it may be useful for testing and learning purposes to be able to run the tools directly on your workstation*

### Knowledge

* You have a working knowledge of Azure; Virtual Networks, Policy, Management Groups, Linux
* You have a working knowledge of [Terraform](https://www.terraform.io/docs/index.html), modules, variables and outputs
* You have a basic knowledge of [Terragrunt](https://terragrunt.gruntwork.io/docs/), dependencies, and inputs
* You are familiar with Git, branching, and the CI/CD tool in use in your organisation

---

## Adding or Modifying modules
These instructions will help you create a module that can be deployed to an environment as part of Foundations. You can also use these instructions if you're modifying an existing module.

### Design
A module should fulfil a specific functional need by deploying a specific set of resources. Think about how the module will be instantiated within the `environments/` tree. Will there be one instance or several instances? Will every instance require the same things, and if not then should it be two separate modules?

### Inputs, outputs and the flow of configuration information
Terraform allows a module to take inputs called "variables" and supply outputs called "outputs".

If you look at the `terragrunt.hcl` files throughout the `environments/` tree, you will see that they form a dependency graph where the outputs of one module are used to supply values for the input variables of another module.

For any resource you will deploy as part of a module, the value for each property must come from somewhere:

* hardcoded values in the module itself
* static files shipped with the module (e.g. a JSON template into which you interpolate input variables)
* input variables that will be specified in a `module.yaml` file
* input variables that will be set from the output of another module with Terragrunt
* "locals" generated within the module (e.g. by transforming input variables, generating a random number, etc)

When relying on the output of another module, ensure that the output is what you need (e.g. where it is an ID, is it formatted in the way you expect?) and think about what kind of checking or cleansing/normalisation you might have to perform before your module can reliably run.

__Note on variables:__ In Terraform, you must explicitly declare the input variables and outputs of a module. That means:

* Every input variable must have a `variable "foo" { ... }` block. You can't just refer to `var.foo` without declaring it.
* If you declare a variable, you must specify a value every time you instantiate the module. If you want the variable to be optional, specify a default in the variable block.
* You can't refer to an attribute of a resource in a module from outside of the module. If there is any attribute which you think might be useful outside of the module (e.g. the ID of a resource which you create), then make it an output.

## Lay out your module's source code
The following standard pattern will help you get started:

* `main.tf` - this is where you will deploy resources (and specify data sources, if any)
* `variables.tf` - this file should contain all variable declarations (and nothing else)
* `outputs.tf` - this file should contain all output blocks (and nothing else)
* `examples/` (optional) -- a place to store Terraform modules which instantiate your module (i.e. `source = "../..."`), useful for testing and for demonstrating the intended use of the module
* `assets/` or `templates/` (optional) -- static files such as JSON templates and test data

A module should usually be kept simple and self-contained enough that the above files are sufficient. If you find yourself creating a file for a specific subject matter or set of resources, then that probably should be a separate module. However, in some cases it may make sense to split the `main.tf` into more than one file.

In any case, it is best to keep the files `variables.tf` and `outputs.tf` with those names, to make it easy for someone to understand your module's connections to the outside world.

## Testing your module in isolation
The module can be tested without integrating it into Foundations, for fast feedback without interfering with other workloads:

* Linting of the Terraform and Terragrunt configuration can be achieved by running `make lint`.
* The command `terraform validate` will check that the `.tf` files in the module are syntactically correct. This will not spot all errors, but will pick up some obvious mistakes such as forgetting to declare a variable or misspelling its name.
* You can also run the `make validate` to validate all modules in your working tree.
* If you have an example configuration in the `examples/` directory, you can `plan` or `apply` it in order to verify that the main module performs as intended.

## Testing your module as part of Foundations
Within your instance of Foundations, you can have both non-production and production environments. For example, you might have `environments/sales-prod/` and `environments/sales-dev/`. You can test your new module by adding it to the non-production environment(s) first.

See below for instructions on how to add an instance of your module to an environment.

## Deploying as part of Foundations
To deploy the module as part of an environment, create a new directory within that environment. For example, to add an instance of the `foo` module to the "sales" environment in Australia East, create the directory `environments/sales/australiaeast/foo/`. Terragrunt will automatically detect, based on the leaf directory name "foo", that it should load the module from `modules/foo/`.

This directory will need to contain the following files:

* `terragrunt.hcl` -- contains the following:
  * a standard `include` block instructing Terragrunt to search for the root `terragrunt.hcl` file, which incorporated further configuration information
  * `dependency` blocks for any modules which either:
    * you want this module to wait for and deploy after
    * you want to pull outputs from to use as inputs in this module
  * an `inputs` block specifying which input variables to pull from which dependencies' outputs
* `module.yaml` (optional) -- to set the value of any variables which are not drawn from other source by `terragrunt.hcl`
