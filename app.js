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
	response.sendFile(path.join(__dirname + '/TotalWarManager.html'));
}
);

app.post('/addFaction', function(request, response){
	var factionName = request.body.name;
	var factionRel = request.body.frel;
	var factionPop = request.body.fpop;
	var query = 'INSERT INTO table_name VALUES(?, ?, ?);';
	connection.query(query, [factionName, factionPop, factionRel], function(error, result, fields){
		if(error) throw error;
		console.log(result);
	}
	);
}
);
//name1 name2 war ally neutral
app.post('/addRelation', function(request, response){
	var name1 = request.body.name1;
	var name2 = request.body.name2;
	var query = 'INSERT INTO table_name VALUES(?, ?, ?);';	
	
	var state;//assumed that only 1 state is not null and rest are null
	if(request.body.war != NULL){
		state = request.body.war;
	}else if(request.body.ally !=NULL){
		state = request.body.ally;
	}else if(request.body.neutral !=NULL){
		state = request.body.neutral;
	}
	//if possible, 
	if(state != NULL){
		connection.query(query, [name1, name2, state], function(error, result, fields){
			if(error) throw error;
			//if(getstate = null) then write to screen that something needs to be entered
		}
		);
	}else{
		//if the above comment doesnt work then do it in this else bracket
	}
	
	

	
}
);

app.post('/updateFaction', function(request, response){
	var factionName = request.body.name;
	var factionRel = request.body.frel;
	var factionPop = request.body.fpop;
	var query = 'INSERT INTO table_name VALUES(?, ?, ?);';
	connection.query(query, [factionName, factionRel, factionPop], function(error, result, fields){
		if(error) throw error;
		console.log(result);
	}
	);
	
	
	
}
);

app.post('/remFaction', function(request, response){
	var factionName = request.body.name;
	var query = 'DELETE FROM table_name WHERE name = ?);';
	connection.query(query, [factionName], function(error, result, fields){
		if(error) throw error;
		console.log(result);
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
	var query = 'INSERT INTO table_name VALUES(?, ?, ? , ?);';
	connection.query(query, [cityName, cityTax, cityPopulation, cityFaction], function(error, result, fields){
		if(error) throw error;
		console.log(result);
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
	var query = 'INSERT INTO table_name VALUES(?, ?, ? , ?);';
	connection.query(query, [strongholdName, strongholdPop, numOfGar, controllingFac], function(error, result, fields){
		if(error) throw error;
		console.log(result);
	}
	);
}
);

//settlement name   numunit  type good damaged destroyed
app.post('/addSmith', function(request, response){
	var settlementName = request.body.name;
	var numOfSmith = request.body.numunit;
	var smithType = request.body.type;
	var state;
	
	var query = 'INSERT INTO table_name VALUES(?, ?, ? , ?);';
	
	
	if(request.body.good != NULL){
		state = request.body.good;
	}else if(request.body.damaged !=NULL){
		state = request.body.damaged;
	}else if(request.body.destroyed !=NULL){
		state = request.body.destroyed;
	}
	//if possible, 
	if(state != NULL){
		connection.query(query, [settlementName, numOfSmith, smithType, state], function(error, result, fields){
			if(error) throw error;
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
	var amountProduced = request.body.num;
	var mineType = request.body.type;
	var state;
	
	var query = 'INSERT INTO table_name VALUES(?, ?, ? , ?);';
	
	
	if(request.body.good != NULL){
		state = request.body.good;
	}else if(request.body.damaged !=NULL){
		state = request.body.damaged;
	}else if(request.body.destroyed !=NULL){
		state = request.body.destroyed;
	}
	//if possible, 
	if(state != NULL){
		connection.query(query, [settlementName, amountProduced, mineType, state], function(error, result, fields){
			if(error) throw error;
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
	var amountProduced = request.body.num;
	var farmType = request.body.type;
	var state;
	
	var query = 'INSERT INTO table_name VALUES(?, ?, ? , ?);';
	
	
	if(request.body.good != NULL){
		state = request.body.good;
	}else if(request.body.damaged !=NULL){
		state = request.body.damaged;
	}else if(request.body.destroyed !=NULL){
		state = request.body.destroyed;
	}
	//if possible, 
	if(state != NULL){
		connection.query(query, [settlementName, amountProduced, farmType, state], function(error, result, fields){
			if(error) throw error;
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
	query = 'INSERT INTO table_name VALUES(?, ?);';
	connection.query(query, [newFaction, settlementName], function(error, result, fields){
			if(error) throw error;
		}
		);
}
);

app.post('/removeRoad', function(request, response){
	var road1 = request.body.name1;
	var road2 = request.body.name2;
	query = 'DELETE FROM table_name WHERE sRoad = ? AND eRoad = ?;';
	connection.query(query, [road1, road2], function(error, result, fields){
			if(error) throw error;
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
	
	query = 'INSERT INTO table_name VALUES(?,?,?,?,?)';
	connection.query(query, [armyName, armyCount, armyHorseCount, controllingFaction, numOfGarrisoned], function(error, result, fields){
		if(error) throw error;
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
		if(error) throw error;
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
		if(error) throw error;
	}
	);
	
}
);
app.post('/moveMilitary', function(request, response){
	var forceName = request.body.name;
	var forceLoc = request.body.loc;
	
	query = 'INSERT INTO table_name VALUES(?,?)';
	connection.query(query, [forceName, forceLoc], function(error, result, fields){
		if(error) throw error;
	}
	);
	
}
);
















