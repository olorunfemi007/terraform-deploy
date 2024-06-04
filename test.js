var name = "Jessi";

console.log("This is the name " + name);

class Vehicle {
    constructor (type){
        this.type = type;
    }
speak(){
console.log("This is the type of car wanted " + this.type);
}
}

class Toyota extends Vehicle {
    constructor (type){
        super(type);
    }
    speak(){
        console.log("This is a toyota but also is of type " + this.type + " " + name);
    }
}

var newObject = new Toyota("SUV");
newObject.speak();

try{

} catch(error){

}

