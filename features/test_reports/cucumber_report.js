var reporter = require('cucumber-html-reporter');

var cucumberReporteroptions = {
  theme: 'simple',
  jsonFile: 'features/test_reports/cucumber_report.json',
  output: 'features/test_reports/cucumber_report.html',
  reportSuiteAsScenarios: true,
  scenarioTimestamp: true,
  launchReport: false,
  ignoreBadJsonFile: false,
};

reporter.generate(cucumberReporteroptions);
