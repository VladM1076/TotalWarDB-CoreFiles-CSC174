var http = require('http');
var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser');
var path = require ('path');
var app = express();


var connection = mysql.createConnection({
	host: 'localhost',
	user: 'root',
	password: '1379', 	//enter root PW here
	database: 'TotalWarDB'
}
);

var server = app.listen(8082, function () {
  var host = server.address().address
  var port = server.address().port
  console.log("Example app listening at %s:%s Port", host, port)
});


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
	var query = 'INSERT INTO FACTION (faction_Name, total_Faction_Population, religion) VALUES(?, 0, ?);';
	
	if (factionName != null && factionRel != null)
	{
		connection.query(query, [factionName, factionRel], function(error, result, fields){
			if(error){
				console.log(error);
			}else{
				console.log(result);
			}
		}
		);
	}
	response.redirect('/TotalWarManager');
}
);

//name1 name2 war ally neutral
app.post('/addRelation', function(request, response){
	var name1 = request.body.name1;
	var name2 = request.body.name2;
	var query;
	
	if (name1 != null && name2 != null)
	{
		if(request.body.rel == "war"){
			
			query = 'SELECT * FROM ALLIED WHERE allied_Faction_Name_1 = ? AND allied_Faction_Name_2 = ? OR allied_Faction_Name_2 = ? AND allied_Faction_Name_1 = ?;';

			connection.query(query, [name1, name2, name1, name2], function(error, result, fields){
				if(result != null){
					var newQuery = 'DELETE FROM ALLIED WHERE allied_Faction_Name_1 = ? AND allied_Faction_Name_2 = ? OR allied_Faction_Name_2 = ? AND allied_Faction_Name_1 = ?;';
					connection.query(newQuery, [name1, name2, name1, name2], function(error, result, fields){
						if(error){
							console.log(error);
						}else{
							console.log(result);
						}
					}
					);
		
				}
			}
			);
			
			query = 'INSERT INTO AT_WAR (warring_Faction_Name_1, warring_Faction_Name_2) VALUES(?, ?);';
			
		}else if(request.body.rel == "ally"){
			
			query = 'SELECT * FROM AT_WAR WHERE warring_Faction_Name_1 = ? AND warring_Faction_Name_2 = ? OR warring_Faction_Name_2 = ? AND warring_Faction_Name_1 = ?;';
			
			connection.query(query, [name1, name2, name1, name2], function(error, result, fields){
				if(result != null){
					var newQuery = 'DELETE FROM AT_WAR WHERE warring_Faction_Name_1 = ? AND warring_Faction_Name_2 = ? OR warring_Faction_Name_2 = ? AND warring_Faction_Name_1 = ?;';
					connection.query(newQuery, [name1, name2, name1, name2], function(error, result, fields){
						if(error){
							console.log(error);
						}else{
							console.log(result);
						}
					}
					);
		
				}
			}
			);
			
			query = 'INSERT INTO ALLIED (allied_Faction_Name_1, allied_Faction_Name_2) VALUES(?, ?);';
			
		}else if(request.body.rel == "neutral"){
			
			query = 'SELECT * FROM AT_WAR WHERE warring_Faction_Name_1 = ? AND warring_Faction_Name_2 = ? OR warring_Faction_Name_2 = ? AND warring_Faction_Name_1 = ?;';

			connection.query(query, [name1, name2, name1, name2], function(error, result, fields){
				
				//console.log(result);
				
				if(result.length != 0)			
					var newQuery = 'DELETE FROM AT_WAR WHERE warring_Faction_Name_1 = ? AND warring_Faction_Name_2 = ? OR warring_Faction_Name_2 = ? AND warring_Faction_Name_1 = ?;';
				
				else				
					var newQuery = 'DELETE FROM ALLIED WHERE allied_Faction_Name_1 = ? AND allied_Faction_Name_2 = ? OR allied_Faction_Name_2 = ? AND allied_Faction_Name_1 = ?;';
				
					
				connection.query(newQuery, [name1, name2, name1, name2], function(error, result, fields){
					if(error){
						console.log(error);
					}else{
						console.log(result);
					}
				}
				);
			}
			);
			response.redirect('/TotalWarManager');
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
	response.redirect('/TotalWarManager');
}
);

app.post('/updateFaction', function(request, response){
	var factionName = request.body.name;
	var factionRel = request.body.frel;
	var query = 'UPDATE FACTION SET religion=? WHERE faction_Name = ?;';
	
	if (factionName != null && factionRel != null)
	{
		connection.query(query, [factionRel, factionName], function(error, result, fields){
			if(error){
				console.log(error);
			}else{
				console.log(result);
			}
		}
		);
	}
	response.redirect('/TotalWarManager');
}
);

app.post('/remFaction', function(request, response){
	var factionName = request.body.name;
	var query = 'DELETE FROM FACTION WHERE faction_Name = ?;';
	
	if (factionName != null)
	{
		connection.query(query, [factionName], function(error, result, fields){
			if(error){
				console.log(error);
			}else{
				console.log(result);
			}
		}
		);
	}
	response.redirect('/TotalWarManager');
}
);


//name ctax cpop cfact
app.post('/addCity', function(request, response){
	var cityName = request.body.name;
	var cityPopulation = request.body.cpop;
	var cityFaction = request.body.cfact;
	var cityTax = request.body.ctax;
	var date = request.body.date;
	var query = 'INSERT INTO SETTLEMENT (settlement_Name, settlement_Population, city_Taxes_Collected, controlled_By_Faction_Name, faction_Date_Settlement_Occupied, settlement_Type) VALUES(?, ?, ? , ?, ? , ?);'; 		//column names might need updating depending on SQL table
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
	var query = 'INSERT INTO SETTLEMENT (settlement_Name, settlement_Population, stronghold_Garrison_Unit_Count, controlled_By_Faction_Name, faction_Date_Settlement_Occupied, settlement_Type) VALUES(?, ?, ? , ?, ? , ?);';		//column names might need updating depending on SQL table
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
	
	var query = 'INSERT INTO STRATEGIC_BUILDING (built_By_Settlement_Name, strategic_Building_Name, structural_Integrity, smith_Type) VALUES(?, ?, ? , ?);';
	
	
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
	}
}
);

app.post('/addMine', function(request, response){
	var settlementName = request.body.name;
	var bName = request.body.bname;
	var mineType = request.body.type;
	var state;
	
	var query = 'INSERT INTO STRATEGIC_BUILDING (built_By_Settlement_Name, strategic_Building_Name, structural_Integrity, resource_Type) VALUES(?, ?, ? , ?);';
	
	
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
	}
}
);

app.post('/addFarm', function(request, response){
	var settlementName = request.body.name;
	var bName = request.body.bname;
	var farmType = request.body.type;
	var state;
	
	var query = 'INSERT INTO STRATEGIC_BUILDING (built_By_Settlement_Name, strategic_Building_Name, structural_Integrity, food_Type) VALUES(?, ?, ? , ?);';
	
	
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
	}
);

app.post('/updateOwnership', function(request, response){
	var settlementName = request.body.name;
	var newFaction = request.body.new;
	query = 'UPDATE SETTLEMENT SET controlled_By_Faction_Name=? WHERE settlement_Name = ?;';		//might need column names updated based on SQL
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
	query = 'DELETE FROM SETTLEMENT_ROAD WHERE road_Between_Settlement_Name_1 = ? AND road_Between_Settlement_Name_2 = ?;';
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
	
	query = 'INSERT INTO MILITARY_FORCE (military_Force_Name, unit_Count, faction_Army_Cavalry_Count, recruited_By_Faction_Name, garrisoned_At_Settlement_Name) VALUES(?,?,?,?,?);';
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
	
	query = 'INSERT INTO MILITARY_FORCE (military_Force_Name, unit_Count, navy_Ship_Count, recruited_By_Faction_Name, garrisoned_At_Settlement_Name) VALUES(?,?,?,?,?);';
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
	
	query = 'INSERT INTO BATTLED (battling_Military_Force_Name_1, battling_Military_Force_Name_2, victor_Faction_Name, attacking_Military_Force_Name_Losses, defending_Military_Force_Name_Losses) VALUES(?,?,?,?,?);';
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
	
	query = 'UPDATE MILITARY_FORCE SET garrisoned_At_Settlement_Name = ? WHERE military_Force_Name = ?;';
	connection.query(query, [forceLoc, forceName], function(error, result, fields){
		if(error){
			console.log(error);
		}else{
			console.log(result);
		}
	}
	);
	
}
);

app.post('/updateMorale', function(request, response){
	var forceName = request.body.name;
	var state = request.body.morale;
	
	query = 'UPDATE MILITARY_FORCE SET morale = ? WHERE military_Force_Name = ?;';
	if(state != NULL && forceName != NULL){
		connection.query(query, [state, forceName], function(error, result, fields){
			if(error) throw error;
			//if(getstate = null) then write to screen that something needs to be entered
		}
		);
	}
	
}
);
