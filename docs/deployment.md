# Deploying Convene

A `convene` Neighborhood will eventually be deployable in several ways.
Currently, we support deploying to:
- Heroku via:
  - GitHub

Each of these methods is discussed in detail below:

## Deploying to Heroku

### GitHub
Deploying from GitHub is perhaps arguably the easiest way to deploy to Heroku,
as it can be done entirely using their GUIs through Heroku-GitHub integration. \
An overview is discussed below,
but please see the [GitHub Integration](https://devcenter.heroku.com/articles/github-integration) page on Heroku's site for details.

#### Steps:
1. Make sure you have both [GitHub](https://github.com/login) and [Heroku](https://id.heroku.com/) accounts.
2. In GitHub, [Fork the `convene` repo](https://github.com/zinc-collective/convene/fork).
3. Inside Heroku:
   1. Make a [new pipeline](https://dashboard.heroku.com/pipelines/new)
      1. Give the pipeline a unique name
      2. Click "`Connect to GitHub`" button, and follow instructions to connect
         1. If you have previously connected with GitHub, you should be able to search and select the repo
      3. Search for and select the appropriate repo (the fork of `convene`)
      4. Click "`Create Pipeline`"
   2. In new pipeline's "`Pipeline`" tab, click "`Add App`" then "`Create new app...`"
      1. Give another unique name
      2. Create
   3. In the new app's "`Deploy`" tab and enable automatic deploys
   4. Go to the app's "`Settings`" tab:
      1. Click "`Add buildpack`", select `nodejs`, then click "`Save changes`"
      2. Click "`Add buildpack`", select `ruby`, then click "`Save changes`"
      3. (These are already specified in the `app.json` file, but this wasn't working during testing.)
   5. You should be able to deploy by either:
      1.  pushing to your "`main`" branch and have it automatically deploy or
      2.  go to the app's "`Deploy`" tab and click the "`Deploy Branch`" button at the bottom of the page.

If you run into issues with this process that are not resolved with a bit of research, please do not hesitate to [contact us](https://www.zinc.coop/contact-us/)!