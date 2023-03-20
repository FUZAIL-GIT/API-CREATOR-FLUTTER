// Future<bool> initializeNodeProject({required String path}) async {
//   String cmd = 'npm init -y';
//   var result =
//       await Process.run(cmd, [], runInShell: true, workingDirectory: path);
//   if (result.exitCode != 0) {
//     log('Error running npm init: ${result.stderr}');
//     return false;
//   } else {
//     log('npm init completed successfully!');
//     return true;
//   }
// }

// Future<bool> installingPackages({required String path}) async {
//   String cmd = 'npm install express mongoose body-parser --save';
//   var result =
//       await Process.run(cmd, [], runInShell: true, workingDirectory: path);

//   if (result.exitCode != 0) {
//     log('Error running npm install express mongoose body-parser --save: ${result.stderr}');
//     return false;
//   } else {
//     log('npm install package successfully!');
//     return true;
//   }
// }
  // await initializeNodeProject(
    //     path: "${downloadDirectoryPath!.path}\\$projectName");
// Future<bool> openCode({required String path}) async {
//   String cmd = 'code .';
//   var result =
//       await Process.run(cmd, [], runInShell: true, workingDirectory: path);

//   if (result.exitCode != 0) {
//     log('Error opening vs code: ${result.stderr}');
//     return false;
//   } else {
//     log('code open successfully!');
//     return true;
//   }
// }

  // await installingPackages(
    //     path: "${downloadDirectoryPath!.path}\\$projectName");
// String mongoDbUrl =
  //     "mongodb+srv://fuzailzaman:EuonUzpvXIMJFF8C@practice.3jxg4to.mongodb.net/?retryWrites=true&w=majority";

//  -----------------------------------------------------------------------------------------------
//* | Methods 	||  Urls 	                    || Actions                                           | 
//* | GET 	    ||  api/tutorials 	          || get all Tutorials                                 | 
//* | GET 	    ||  api/tutorials/:id 	      || get Tutorial by id                                |
//* | POST 	    ||  api/tutorials 	          || add new Tutorial                                  |    
//* | PUT 	    ||  api/tutorials/:id 	      || update Tutorial by id                             |     
//* | DELETE 	  ||  api/tutorials/:id 	      || remove Tutorial by id                             |       
//* | DELETE  	||  api/tutorials             || remove all Tutorials                              |      
//* | GET 	    ||  api/tutorials/published 	|| find all published Tutorials                      |     
//* | GET 	    ||  api/tutorials?title=[kw] 	|| find all Tutorials which title contains 'kw'      |      
//  -----------------------------------------------------------------------------------------------