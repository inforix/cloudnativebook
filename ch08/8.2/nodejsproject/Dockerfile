# 注意替换registry
FROM node:10
WORKDIR /usr/src/app
COPY package*.json ./
# RUN npm install --registry <LOCAL NPM REGISTRY URL> 
RUN npm ci --only=production
# Bundle app source
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
