const { defineParameterType } = require("cucumber");

// This injects a Workspace class into steps with named Workspaces (i.e.)
// `the "Convene Demo" Workspace` and steps that mention `Workspace` in
// isolation.
defineParameterType({
  name: "workspace",
  regexp: /"([^"]*)" ?Workspace/,
  transformer: (workspace) => new Workspace(workspace),
});

class Workspace {
  constructor(workspaceName) {
    this.name = workspaceName;
    this.slug = workspaceName.replace(/\s+/g, '-').toLowerCase();
  }
}

module.exports = Workspace;