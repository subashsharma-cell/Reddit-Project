FROM node:19-alpine3.15

WORKDIR /reddit-clone

COPY . /reddit-clone
RUN npm install 

# 1. ADDED: This compiles the code now (so it doesn't happen when a user clicks)
RUN npm run build

EXPOSE 3000

# 2. CHANGED: Use 'start' (Production) instead of 'dev' (Development)
CMD ["npm","start"]