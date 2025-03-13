[![Most Recent Release](https://img.shields.io/github/v/release/Martijho/cicd_template)](https://github.com/Martijho/cicd_template/releases/latest)
![Latest Release](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Martijho/a55d7787586c5e7f5b7e09588757e696/raw/latest.json)
![Stable Release](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/Martijho/7a50d807ec91d1e85af92d83f0949631/raw/stable.json)

# cicd_template
Template for CI/CD workflows 

## TODO


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
