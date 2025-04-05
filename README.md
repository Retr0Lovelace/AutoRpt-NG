# AutoRpt-NG

AutoRpt-NG is a command-line tool for generating and managing cybersecurity reports from pre-defined templates. It allows you to create, list, delete, and archive reports automatically with simple commands.

## Prerequisites

- `fzf`: An interactive search tool.
- `zip`: Used to compress reports into `.zip` files.
- `date`: Command for handling dates.

## Installation

Clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/AutoRpt-NG.git
cd AutoRpt-NG
```

Install the required dependencies:

```bash
sudo ./setup.sh
```

## Usage

### Interactive Mode

Run the application with the following command to access the interactive menu:

```bash
autorpt-ng
```

In the interactive menu, you can choose from the following options:

- List templates: Displays the available templates in the templates folder.
- Create a new report: Creates a report from an existing template.
- List reports: Displays the existing reports in the reports folder.
- Delete a report: Deletes an existing report.
- Archive a report: Creates a `.zip` archive of a report.

![](img/demo.gif)

### Batch Mode

You can use AutoRpt-NG in batch mode with the following commands:

```bash
autorpt-ng list template                   # Lists available templates
autorpt-ng list report                     # Lists available reports
autorpt-ng create <template> <report_name>  # Creates a report
autorpt-ng delete <report_name>            # Deletes a report
autorpt-ng archive <report_name>           # Archives a report in .zip
```

![](img/demo1.gif)

## Contributing

If you would like to contribute to this project, here are the steps to follow:

- Fork this repository.
- Create a branch for your feature or bugfix (**git checkout -b feature/new-feature**).
- Commit your changes (**git commit -am 'Added new feature'**).
- Push to your branch (**git push origin feature/new-feature**).
- Open a pull request.

## License

This project is licensed under the GPL-3.0 License. See the LICENSE file for more details.