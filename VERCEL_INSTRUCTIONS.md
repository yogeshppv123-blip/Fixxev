# 🚀 How to Fix "Connection Refused" / "No Data" on Vercel

The issue is that your deployed website is trying to connect to `localhost` (your computer). This works on YOUR computer but fails everywhere else.

**You must point Vercel to your deployed Render Backend.**

## 1. Get your Backend URL
Your backend is deployed at:
> `https://fixxev-backend.onrender.com/api`

## 2. Configure Vercel (Do this for BOTH User and Admin projects)

1.  Go to your **Vercel Dashboard**.
2.  Select your Project (e.g., `fixxev` or `fixxev-admin`).
3.  Click **Settings** (top menu).
4.  Click **Environment Variables** (left sidebar).
5.  Add a new variable:
    *   **Key**: `API_URL`
    *   **Value**: `https://fixxev-backend.onrender.com/api`
6.  Click **Save**.

## 3. Redeploy (Critical!)
Variables are only applied during the build.

1.  Go to the **Deployments** tab.
2.  Click the **three dots (...)** next to the latest deployment.
3.  Select **Redeploy**.

## 4. Done!
Once the redeploy finishes, your website will connect to the Render backend and will work on ANY computer or mobile device.
