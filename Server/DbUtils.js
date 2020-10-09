const Utils = require('./Utils');
const { MongoClient, ObjectId } = require('mongodb');
const fs = require('fs');
require('dotenv').config();
const MONGO_URL = process.env.MONGO_URI;



function ResolveEffectsFromStr(effectStr){
    let effects=  {};
    console.log(effectStr);
    let effectsArrStrs = effectStr.split('\r\n');
    effectsArrStrs.shift();

    effectsArrStrs.forEach((eff)=>{
        if(eff.trim()){
        let [effectField,effectVal]  = eff.split(':');
        effects[effectField.toLowerCase()] = parseInt(effectVal); 
    }});  
    return effects;
}

function CreateImplicationModel(implicationsStr){
    let implications=[];
    implicationsStr =implicationsStr.trim();
    let implcationsStrArr = implicationsStr.split('*');
    implcationsStrArr.forEach((implicationStr)=>{
        if(implicationStr.trim()){
        let implication = {};
        implication.text = implicationStr.split("\r\n")[0];
    if(implicationStr.includes(':')){

         implication.effect = ResolveEffectsFromStr(implicationStr);
        
    }
    implications.push(implication);
    }});
    return implications;

}

function InsertQuestionsFromDoc(){
//this is bad ad-hok code made for intrensic use 
fs.readFile('assets/QuestionSet.txt',"utf8",(err,txt)=>{
        let questions = txt.split('---');

        questions.forEach((questionData,idx)=>{
            questionData = questionData.replace("\r\n",'');
            questionData = questionData.trim();
            if(questionData){
                let text = questionData.split('#')[1]; //question between two #
                let confirmImplication = CreateImplicationModel(questionData.split('V')[1]);
                let rejectImplication = CreateImplicationModel(questionData.split('X')[1]);
                questionData = {text,confirmImplication,rejectImplication};
                console.log(questionData);
                try {
                    
                    const client = MongoClient.connect(MONGO_URL, async (e, client) => {
                        const db = client.db('TinderClone');
                        await db.collection('Questions').insertOne(questionData);
                    });
                } catch (ex) {
                    console.error(ex);
                }
            }
})
});
}
InsertQuestionsFromDoc();