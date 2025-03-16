<table>
  <tr>
    <td width="50%" style="text-align: left;">

| Releases      | Version |
|---------------|---------|
| Current       | [![Most Recent Release](https://img.shields.io/github/v/release/Martijho/cicd_template)](https://github.com/Martijho/cicd_template/releases/latest) |
| Latest        | ![Latest](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Martijho/a55d7787586c5e7f5b7e09588757e696/raw/latest.json)  |
| Stable        | ![Stable](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Martijho/7a50d807ec91d1e85af92d83f0949631/raw/stable.json) |
| Full history  | [here](https://gist.github.com/Martijho/cdc1e310d9f336ef1c7543d1e3cea78e) |

   </td>
    <td width="50%" style="text-align: left;">

| Workflows        | Status |
|------------------|--------|
| Pytests          | [![Module A](https://github.com/Martijho/cicd_template/actions/workflows/test_module_a.yml/badge.svg)](https://github.com/Martijho/cicd_template/actions/workflows/test_module_a.yml) <br> [![Module B](https://github.com/Martijho/cicd_template/actions/workflows/test_module_b.yml/badge.svg)](https://github.com/Martijho/cicd_template/actions/workflows/test_module_b.yml) <br> [![Module C](https://github.com/Martijho/cicd_template/actions/workflows/test_module_c.yml/badge.svg)](https://github.com/Martijho/cicd_template/actions/workflows/test_module_c.yml) |
| Formatting       | [![Black](https://github.com/Martijho/cicd_template/actions/workflows/black_formatting.yml/badge.svg)](https://github.com/Martijho/cicd_template/actions/workflows/black_formatting.yml) |
| SonarQube        | ![Quality Gate](https://sonarcloud.io/api/project_badges/measure?project=Martijho_cicd_template&metric=alert_status) <br> ![Coverage](https://sonarcloud.io/api/project_badges/measure?project=Martijho_cicd_template&metric=coverage) <br> ![Bugs](https://sonarcloud.io/api/project_badges/measure?project=Martijho_cicd_template&metric=bugs) <br> ![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=Martijho_cicd_template&metric=vulnerabilities) |
   </td>
  </tr>
</table>

# cicd_template
This repo is a template for the GITHUB part of a CI/CD system, where the workflows can be built upon to include code-release to dev and prod. 

The idea is to add rules to the repository so only PRs can commit to main, and only a select few can push tags to the repo. 

### PRs
Every time a PR is opened to main, the workflow `main_merge` is triggered. This workflow runs pytests and if they pass, the PR might be merged with main.

### Release
When a commit in main is deemed release-worthy, the commit should be tagged with a release version following the `vMAJOR.MINOR.PATCH` format.
This triggers the `release_tag` workflow which verifies that the version follows the correct format, and creates a new release in github with that version. 

Running `./scripts/bump_version.sh` with the parameter `patch`, `minor` or `major` will increase the version appropriatly and push the new tag

### Latest and Stable
There are two other tags `latest` and `stable`, which points to some commits. These commits are considered `latest` and `stable` (shocker!), 
and will always be placed on a commit which is also a release. 
Changing the location of this tag causes the workflow `latest_pointer` or `stable_pointer` to run. They include some boilerplate to update some GISTs
for the repository, so that the shields at the top of this readme works (see setup bellow).

When implementing this template in a project, these workflows can be updated to include steps for rolling out the `latest`/`stable` commit in production or development environments. 
The workflows extract the commits release tag and adds it to `$GITHUB_ENV` so it can be retrieved in the workflow as `${{ env.VERSION_TAG }}`. Usefull for tagging docker images for example.

The scripts `./scripts/update_latest.sh` and `./scripts/update_stable.sh` will move the respective tag to the version provided to the script. 
     
### Other workflows 
There are three test-workflows which generates result-shields. Integration of these can be found in the top of this readme. 
There are also a workflow for formatting check using the black standard. This is setup so that a black check runs for every push to main, but will not fail your PR

This example repo is integrated with SonarQube. This is a third party service which has its own setup. 

## Setup Guide for Gist, Tokens, and Secrets

This guide explains how to set up a Gist, create a token, and add the necessary secrets to your GitHub repository for use with GitHub Actions. Three gists are used for this repo `latest.json`, `stable.json` and `history.json`

1. Go to [GitHub Gists](https://gist.github.com/).
2. Create 3 new secret Gists: 
#### latest.json
```json
{
  "schemaVersion": 1,
  "label": "Latest Release",
  "message": "v0.0.0",
  "color": "blue"
}
```
#### stable.json
```json
{
  "schemaVersion": 1,
  "label": "Stable Release",
  "message": "v0.0.0",
  "color": "blue"
}
```
#### history.json
```json
{
  "stable-history": [],
  "latest-history": []
}
```
3. Note the gist IDs found in the URL. `https://gist.github.com/YOUR_USERNAME/GIST_ID`
4. Go to [GitHub Personal Access Tokens](https://github.com/settings/tokens) and generate a new token. Make sure to enable  **"gist"** permission (you can leave others unchecked)
5. Go to your repository **Settings > Secrets and variables > Actions** and add 4 new secrets
- `GIST_TOKEN` -> The newly create access token with gist permission
- `GIST_ID_LATEST` -> The ID to the `latest.json` gist
- `GIST_ID_STABLE` -> The ID to the `stable.json` gist
- `GIST_ID_HISTORY` -> The ID to the `history.json` gist
