## Using the convene-devcontainer

This is usable either on your local machine in VS Code or in a GitHub Codespace.

To use the devcontainer:
- On your machine, install the "Dev Containers" extension, hit `Ctrl + Shift + P`, type "container", then select an option to open this workspace in a container.
  -  The specific option varies depending on state, but most should get you to the same final state.
- On GitHub, follow the instructions on [this page](https://docs.github.com/en/codespaces/developing-in-codespaces/creating-a-codespace-for-a-repository#creating-a-codespace-for-a-repository) ("Creating a codespace for a repository"). 
  - Note that information on payment has not been discussed.

Once the devcontainer has been started, some stuff will be executing in the background. 
This may take a few minutes, especially on the lower-powered GitHub CodeSpace VMs.
See the files in `.devcontainer/output` to view how setup is progressing. 

Once `bin/run` has been called, you should soon be able to access the app in your browser:
- Go to 'Ports' tab of the terminal pane
- Wait for Port 3000 to show up in left-hand column
- Click on the globe 🌐 (Open in Browser) under 'Local Address next to the entry for Port 3000.
A browser tab should open showing the convene landing page. 

Happy contributing!
