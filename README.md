# template.dockerized-provisioning-project

[![default](https://github.com/mazgi/template.dockerized-provisioning-project/workflows/default/badge.svg)](https://github.com/mazgi/template.dockerized-provisioning-project/actions?query=workflow%3Adefault)

## How to set up

You need one AWS account and one GCP project which you can fully manage.  
And you should get credentials after you set up system accounts as below for provisioning.

### How to set up your AWS IAM user

You should create an AWS IAM user named `provisioning-admin` that attached follows permissions.

- `AdministratorAccess`

### How to set up your GCP service account

You should create a GCP service account named `provisioning-owner` that added follows roles.

- `Project Owner`
- `Storage Admin`

### How to set up your local environment

You should create the ".env" file as follows.

```shellsession
rm -f .env
test $(uname -s) = 'Linux' && echo "UID=$(id -u)\nGID=$(id -g)" >> .env
cat<<EOE > .env
AWS_ACCOUNT_ID=YOUR_AWS_ACCOUNT_ID
CLOUDSDK_CORE_PROJECT=YOUR_GCP_PROJECT_ID
CURRENT_ENV_NAME=production
PROJECT_UNIQUE_ID=YOUR_GCP_PROJECT_UNIZUE_ID
EOE
```

Place your credentials as follows.

```shellsession
eval $(op signin my)
source .env
op get document arn:aws:iam::${AWS_ACCOUNT_ID}:user/provisioning-admin > config/${CURRENT_ENV_NAME}/credentials/new_user_credentials.csv
op get document provisioning-owner@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com > config/${CURRENT_ENV_NAME}/credentials/google-cloud-keyfile.json
```

You should update the ".env" file as follows.

```shellsession
source .env
echo "AWS_ACCESS_KEY_ID=$(tail -1 config/${CURRENT_ENV_NAME}/credentials/new_user_credentials.csv | cut -d, -f3)" >> .env
echo "AWS_SECRET_ACCESS_KEY=$(tail -1 config/${CURRENT_ENV_NAME}/credentials/new_user_credentials.csv | cut -d, -f4)" >> .env
```

## How to run

Now you can make provisioning as follows.

```shellsession
docker-compose up
docker-compose run provisioning terraform plan
```
