const { Sequelize } = require("sequelize");

const sequelize = new Sequelize(
  "project-manegment",
  "root",
  "yazan0791490616",
  { dialect: "mysql", host: "localhost",logging: false }
);

module.exports = sequelize;
