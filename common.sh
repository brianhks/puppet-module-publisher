#Check if librarian-puppet is installed
command -v librarian-puppet >/dev/null 2>&1 || { echo -e >&2 "librarian-puppet is required, install with: \n>sudo gem install librarian-puppet.\nYou will also need ruby-dev installed."; exit 1; }

NEXUS_URL=http://localhost:8081
NEXUS_USER=admin
NEXUS_PASSWORD=admin123
NEXUS_REPOSITORY=puppet


