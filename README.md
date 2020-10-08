# template.dockerized-provisioning-project

[![default](https://github.com/mazgi/template.dockerized-provisioning-project/workflows/default/badge.svg)](https://github.com/mazgi/template.dockerized-provisioning-project/actions?query=workflow%3Adefault)

## How to run

You should create a ".env" file as bellows.

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

Place the key-file like this.

```shellsession
eval $(op signin my)
source .env
op get document arn:aws:iam::${AWS_ACCOUNT_ID}:user/provisioning-admin > config/${CURRENT_ENV_NAME}/credentials/new_user_credentials.csv
op get document provisioning-owner@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com > config/${CURRENT_ENV_NAME}/credentials/google-cloud-keyfile.json
```

You should update the ".env" file as bellows.

```shellsession
echo "AWS_ACCESS_KEY_ID=$(tail -1 config/${CURRENT_ENV_NAME}/credentials/new_user_credentials.csv | cut -d, -f3)" >> .env
echo "AWS_SECRET_ACCESS_KEY=$(tail -1 config/${CURRENT_ENV_NAME}/credentials/new_user_credentials.csv | cut -d, -f4)" >> .env
```

```shellsession
docker-compose up
docker-compose run provisioning terraform plan
```
