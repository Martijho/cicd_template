<table>
  <tr>
     <td width="50%" align="left">

| Pointer          | Version |
|------------------|---------|
| Current release    | [![Most Recent Release](https://img.shields.io/github/v/release/Martijho/cicd_template)](https://github.com/Martijho/cicd_template/releases/latest) |
| Latest             | ![Latest](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Martijho/a55d7787586c5e7f5b7e09588757e696/raw/latest.json)  |
| Stable             | ![Stable](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Martijho/7a50d807ec91d1e85af92d83f0949631/raw/stable.json) |
| Full history       | [here](https://gist.github.com/Martijho/cdc1e310d9f336ef1c7543d1e3cea78e) |

   </td>
    <td width="50%" align="right">

| Workflow         | Status |
|------------------|--------|
| Pytests          |  
|                  | <table>  
|                  | <tr><td> Module A </td><td> [![Module A](https://github.com/Martijho/cicd_template/actions/workflows/test_module_a.yml/badge.svg)](https://github.com/Martijho/cicd_template/actions/workflows/test_module_a.yml) </td></tr> |
|                  | <tr><td> Module B </td><td> [![Module B](https://github.com/Martijho/cicd_template/actions/workflows/test_module_b.yml/badge.svg)](https://github.com/Martijho/cicd_template/actions/workflows/test_module_b.yml) </td></tr> |
|                  | <tr><td> Module C </td><td> [![Module C](https://github.com/Martijho/cicd_template/actions/workflows/test_module_c.yml/badge.svg)](https://github.com/Martijho/cicd_template/actions/workflows/test_module_c.yml) </td></tr> |
|                  | </table> |
| Formatting       | [![Black](https://github.com/Martijho/cicd_template/actions/workflows/black_formatting.yml/badge.svg)](https://github.com/Martijho/cicd_template/actions/workflows/black_formatting.yml) |
| SonarQube        | ![Quality Gate](https://sonarcloud.io/api/project_badges/measure?project=Martijho_cicd_template&metric=alert_status) ![Coverage](https://sonarcloud.io/api/project_badges/measure?project=Martijho_cicd_template&metric=coverage) ![Bugs](https://sonarcloud.io/api/project_badges/measure?project=Martijho_cicd_template&metric=bugs) ![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=Martijho_cicd_template&metric=vulnerabilities) |

   </td>
  </tr>
</table>


Full release history 
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
     

## Setup Guide for Gist, Tokens, and Secrets

This guide explains how to set up a Gist, create a token, and add the necessary secrets to your GitHub repository for use with GitHub Actions.
The examples in this guide uses `latest`. Repeate the step for `stable` to get both shields

### Step 1: Create a Public Gist
1. Go to [GitHub Gists](https://gist.github.com/).
2. Click **"New Gist"**.
3. Set a name for the file (e.g., `latest.json`) and add the following JSON content:
    ```json
    {
      "schemaVersion": 1,
      "label": "Latest Release",
      "message": "v0.0.0",
      "color": "blue"
    }
    ```
4. Click **"Create public Gist"**. Ensure the Gist is public.

### Step 2: Get Your Gist ID
1. After creating the Gist, you'll be redirected to its page.
2. The URL will look like:  
    `https://gist.github.com/YOUR_USERNAME/GIST_ID`.
3. Copy the **`GIST_ID`** (the alphanumeric string after your GitHub username).

### Step 3: Create a GitHub Personal Access Token
1. Go to [GitHub Personal Access Tokens](https://github.com/settings/tokens).
2. Click **"Generate new token"**.
3. Enable **"gist"** permission (you can leave others unchecked).
4. Click **"Generate token"**.
5. **Copy** the token immediately (you won’t be able to view it again).

### Step 4: Add Secrets to Your GitHub Repository
1. Go to your **GitHub repository**.
2. Navigate to **Settings > Secrets and variables > Actions**.
3. Click **"New repository secret"**.
4. Add the following secrets:
   - **Secret Name**: `GIST_ID_LATEST`  
     **Value**: Your **Gist ID** (copied in Step 2).
   - **Secret Name**: `GIST_TOKEN_LATEST`  
     **Value**: The **GitHub Token** (copied in Step 3).
