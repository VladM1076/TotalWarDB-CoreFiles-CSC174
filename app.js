var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser');
var path = require ('path');
var app = express();

var connection = mysql.createConnection({
	host: 'localhost',
	user: 'root',
	password: 'DBpw',
	database: 'DBname'
}
);

app.use(bodyParser.urlencoded({ extended : true}));
app.use(bodyParser.json());
app.use(express.static(__dirname + '/'));//enable css and js files 

app.get('/TotalWarManager', function(request, response){
	response.sendFile(path.join(__dirname + '/index.html'));
}
);

app.post('/addFaction', function(request, response){
	var factionName = request.body.name;
	var factionRel = request.body.frel;
	var query = 'INSERT INTO FACTION (fName, religion) VALUES(?, ?);';
	
	connection.query(query, [factionName, factionRel], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
}
);

//name1 name2 war ally neutral
app.post('/addRelation', function(request, response){
	var name1 = request.body.name1;
	var name2 = request.body.name2;
	var query;
	
	if(request.body.war != NULL){
		query = 'INSERT INTO AT_WAR VALUES(?, ?);';
	}else if(request.body.ally !=NULL){
		query = 'INSERT INTO ALLIED VALUES(?, ?);';
	}else if(request.body.neutral != NULL){
		query = 'SELECT FROM AT_WAR WHERE fname1 = ? AND fname2 = ?;';

		connection.query(query, [name1, name2], function(error, result, fields){
			if(result != NULL){
				var newQuery = 'DELETE FROM AT_WAR WHERE fname1 = ? AND fname2 = ?;';
				connection.query(newQuery, [name1, name2], function(error, result, fields){
					if(error){
						console.log(error);
					}else{
						console.log(result);
					}
				}
				);
	
			}else{
				var newQuery = 'DELETE FROM ALLIED WHERE fname1 = ? AND fname2 = ?;';
				connection.query(newQuery, [name1, name2], function(error, result, fields){
					if(error){
						console.log(error);
					}else{
						console.log(result);
					}
				}
				);
				
			}//end if-else
		}
		);
		return;
	}//end else-if
	
	//
	connection.query(query, [name1, name2], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
}
);

app.post('/updateFaction', function(request, response){
	var factionName = request.body.name;
	var factionRel = request.body.frel;
	var query = 'UPDATE FACTION SET religion=? WHERE fName = ?;';
	
	connection.query(query, [factionRel, factionName], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
	
	
	
}
);

app.post('/remFaction', function(request, response){
	var factionName = request.body.name;
	var query = 'DELETE FROM table_name WHERE name = ?);';
	connection.query(query, [factionName], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
}
);


//name ctax cpop cfact
app.post('/addCity', function(request, response){
	var cityName = request.body.name;
	var cityPopulation = request.body.cpop;
	var cityFaction = request.body.cfact;
	var cityTax = request.body.ctax;
	var date = request.body.date;
	var query = 'INSERT INTO SETTLEMENT (sName, Population, taxesCollected, controlledBy, date_Occupied, settlement_Type) VALUES(?, ?, ? , ?, ? , ?);'; 		//column names might need updating depending on SQL table
	connection.query(query, [cityName, cityPopulation, cityTax, cityFaction, date, 'C'], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		};
	}
	);
}
);

//name numunit spop cfact
app.post('/addStronghold', function(request, response){
	var strongholdName = request.body.name;
	var numOfGar = request.body.numunit;
	var strongholdPop = request.body.spop;
	var controllingFac = request.body.cfact;
	var date = request.body.date;
	var query = 'INSERT INTO SETTLEMENT (sName, Population, Garrison_Unit_Count, controlledBy, date_Occupied, settlement_Type) VALUES(?, ?, ? , ?, ? , ?);';		//column names might need updating depending on SQL table
	connection.query(query, [strongholdName, strongholdPop, numOfGar, controllingFac, date, 'S'], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
}
);

//settlement name   numunit  type good damaged destroyed
app.post('/addSmith', function(request, response){
	var settlementName = request.body.name;
	var bName = request.body.bname;
	var smithType = request.body.type;
	var state;
	
	var query = 'INSERT INTO STRATEGIC_BUILDING (sName, sB_Name, structural_Integrity, smithType) VALUES(?, ?, ? , ?);';
	
	
	if(request.body.good != NULL){
		state = request.body.good;
	}else if(request.body.damaged !=NULL){
		state = request.body.damaged;
	}else if(request.body.destroyed !=NULL){
		state = request.body.destroyed;
	}
	//if possible, 
	if(state != NULL){
		connection.query(query, [settlementName, bName, state, smithType], function(error, result, fields){
			if(error){
				console.log(error);
			}else{
				console.log(result);
			}
			//if(getstate = null) then write to screen that something needs to be entered
		}
		);
	}else{
		//if the above comment doesnt work then do it in this else bracket
	}
}
);

app.post('/addMine', function(request, response){
	var settlementName = request.body.name;
	var bName = request.body.bname;
	var mineType = request.body.type;
	var state;
	
	var query = 'INSERT INTO STRATEGIC_BUILDING (sName, sB_Name, structural_Integrity, resourceType) VALUES(?, ?, ? , ?);';
	
	
	if(request.body.good != NULL){
		state = request.body.good;
	}else if(request.body.damaged !=NULL){
		state = request.body.damaged;
	}else if(request.body.destroyed !=NULL){
		state = request.body.destroyed;
	}
	//if possible, 
	if(state != NULL){
		connection.query(query, [settlementName, bName, state, mineType], function(error, result, fields){
			if(error){
				console.log(error);
			}else{
				console.log(result);
			}
			//if(getstate = null) then write to screen that something needs to be entered
		}
		);
	}else{
		//if the above comment doesnt work then do it in this else bracket
	}
}
);

app.post('/addFarm', function(request, response){
	var settlementName = request.body.name;
	var bName = request.body.bname;
	var farmType = request.body.type;
	var state;
	
	var query = 'INSERT INTO STRATEGIC_BUILDING (sName, sB_Name, structural_Integrity, foodType) VALUES(?, ?, ? , ?);';
	
	
	if(request.body.good != NULL){
		state = request.body.good;
	}else if(request.body.damaged !=NULL){
		state = request.body.damaged;
	}else if(request.body.destroyed !=NULL){
		state = request.body.destroyed;
	}
	//if possible, 
	if(state != NULL){
		connection.query(query, [settlementName, bName, state, farmType], function(error, result, fields){
			if(error){
				console.log(error);
			}else{
				console.log(result);
			}
			//if(getstate = null) then write to screen that something needs to be entered
		}
		);
	}else{
		//if the above comment doesnt work then do it in this else bracket
	}
}
);

app.post('/updateOwnership', function(request, response){
	var settlementName = request.body.name;
	var newFaction = request.body.new;
	query = 'UPDATE SETTLEMENT SET controlledBy=? WHERE sName = ?;';		//might need column names updated based on SQL
	connection.query(query, [newFaction, settlementName], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
}
);

app.post('/removeRoad', function(request, response){
	var road1 = request.body.name1;
	var road2 = request.body.name2;
	query = 'DELETE FROM SETTLEMENT_ROAD WHERE sRoad = ? AND eRoad = ?;';
	connection.query(query, [road1, road2], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
}
);

app.post('addArmy', function(request, response){
	var armyName = request.body.name;
	var armyCount = request.body.numunit;
	var armyHorseCount = request.body.numhorse;
	var controllingFaction = request.body.cfact;
	var numOfGarrisoned = request.body.gar;
	
	query = 'INSERT INTO MILITARY_FORCE (mName, unit_Count, cavalry_Count, ) VALUES(?,?,?,?,?)';
	connection.query(query, [armyName, armyCount, armyHorseCount, controllingFaction, numOfGarrisoned], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
	
}
);

app.post('/addNavy', function(request, response){
	var navyName = request.body.name;
	var navyCount = request.body.numunit;
	var navyShipCount = request.body.numship;
	var controllingFaction = request.body.cfact;
	var numOfGarrisoned = request.body.gar;
	
	query = 'INSERT INTO table_name VALUES(?,?,?,?,?)';
	connection.query(query, [navyName, navyCount, navyShipCount, controllingFaction, numOfGarrisoned], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
	
}
);

app.post('/addBattle', function(request, response){
	var armyName1 = request.body.name1;
	var armyName2 = request.body.name2;
	var attLoss = request.body.attloss;
	var defLoss = request.body.defloss;
	var victor = request.body.victor;
	
	query = 'INSERT INTO table_name VALUES(?,?,?,?,?)';
	connection.query(query, [armyName1, armyName2, victor, attLoss, defLoss], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
	
}
);
app.post('/moveMilitary', function(request, response){
	var forceName = request.body.name;
	var forceLoc = request.body.loc;
	
	query = 'INSERT INTO table_name VALUES(?,?)';
	connection.query(query, [forceName, forceLoc], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
	
}
);















