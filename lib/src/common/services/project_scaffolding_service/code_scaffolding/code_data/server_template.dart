import 'dart:developer';

import 'package:api_creator/src/common/enums/enums.dart';

import '../../../../models/server_auth_model.dart';

String serverTemplate({required ServerAuthentication serverAuthentication}) {
  log(serverAuthentication.authenticationLevel.toString());
  return '''
const express = require("express");
const config = require("./app/config/config.js");
const swaggerUi = require('swagger-ui-express');
const yaml = require("yamljs");
${serverAuthentication.authenticationLevel != AuthenticationLevel.NONE.name ? 'const middleware = require("./app/middleware/middleware.js");' : ''}
const mongoose = require("mongoose");
const app = express();
const bodyParser = require('body-parser')
const jsonParser = bodyParser.json();
app.use(jsonParser);
const apiDocumentation = yaml.load('documentation.yaml');
app.use('/api-docs' , swaggerUi.serve , swaggerUi.setup(apiDocumentation))
${serverAuthentication.authenticationLevel == AuthenticationLevel.BASIC.name ? 'app.use(middleware.basicAuthentication);' : serverAuthentication.authenticationLevel == AuthenticationLevel.TOKEN.name ? 'app.use(middleware.bearerAuthentication);' : ''}
require("./app/routes/app_routes")(app);

console.log("Api Documentation Available at : http://localhost:8080/api-docs")

mongoose.Promise=global.Promise;
mongoose
  .connect(config.mongoDbUrl, {
    useNewUrlParser: true,
    useUnifiedTopology: true
  })
  .then(() => {
    console.log("Connected to the database!");
  })
  .catch(err => {
    console.log("Cannot connect to the database!", err);
    process.exit();
  });


// entry route
app.get("/", (req, res) => {
  res.json({ message: "Welcome to Your Server." });
});

// set port, listen for requests
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
 console.log(`Server is running on port \${PORT}.`);
});

''';
}


//     var methods = [
        
//     {
//       METHOD: "GET",
//       URL: "http://localhost:8080/api/$modalName",
//       ACTION: "To fetch all the documents from the $modalName collection",
//     },
//     {
//       METHOD: "GET",
//       URL: "http://localhost:8080/api/$modalName/:id",
//       ACTION: "To fetch the specific document from the $modalName collection",
//     },
//     {
//       METHOD: "POST",
//       URL: "http://localhost:8080/api/$modalName",
//       ACTION: "To create the document in the $modalName collection",
//     },
//     {
//       METHOD: "PUT",
//       URL: "http://localhost:8080/api/$modalName/:id",
//       ACTION: "To update a specific document from the $modalName collection",
//     },
//     {
//       METHOD: "DELETE",
//       URL: "http://localhost:8080/api/$modalName",
//       ACTION: "To delete the whole $modalName collection",
//     },
//     {
//       METHOD: "DELETE",
//       URL: "http://localhost:8080/api/$modalName/:id",
//       ACTION: "To delete the specific document from the $modalName collection",
//     },
//   ];
//   console.table(methods);