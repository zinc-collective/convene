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

process.on('unhandledRejection', (err, p) => {
  console.log('An unhandledRejection occurred');
  console.log(`Rejected Promise: ${p}`);
  console.log(`Rejection: ${err}`);
  process.exit(0);
});
