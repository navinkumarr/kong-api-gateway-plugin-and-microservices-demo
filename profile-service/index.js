const http = require('http');

const express = require('express');
const app = express();
const port = 3000;
const dbProfiles = require('./profiles.json');

function failure(res, status, message) {
    return res.send({
        error : {
            message 
        }
    });
}

function success(res, status, response) {
    return res.send({
        data : response
    });
}

app.get('/profiles', (req, res) => {
    let profiles = req.query.profileids;

    if(!profiles) {
        return failure(res, 400, "Invalid Request");
    }

    console.log(profiles);

    let response = [];
    
    profiles.split(',').forEach((profile) => {
        if(profile in dbProfiles) {
            response.push(dbProfiles[profile]);
        }
    });

    if(response.length < 1){
        return failure(res, 400, "Profile not found");
    }

    return success(res, 200, response);
});

app.listen(port, () => {
    console.log(`profile service listening on port ${port}!`);
});
