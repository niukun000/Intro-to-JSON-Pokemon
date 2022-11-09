//
//  NetworkManager.swift
//  IntroJSON
//
//  Created by Kun Niu on 11/8/22.
//

import Foundation

final class NetworkManager{
    static let shared = NetworkManager()
    
    private init(){
        
    }
    
}

extension NetworkManager{
    
    func getDragon () -> Dragon?{
        guard let path = Bundle.main.path(forResource: "SampleJSONDragon", ofType: "json") else {
            print("path")
            return nil
        }
        
        let url = URL(filePath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let jsonObj = try JSONSerialization.jsonObject(with: data)
            guard let baseDict = jsonObj as? [String: Any] else{
                print("fail to get base dict")
                return nil}
//            print(baseDict)
            return self.parsePokemontediously(base: baseDict)
        }
        catch{
            print ("error when converting data to object")
            return nil
        }
    }
    
    func parsePokemontediously(base : [String: Any]) -> Dragon?{
        guard let damageRelations = base["damage_relations"] as? [String: Any]
        else {
            print("damage relations dict")
            return nil}
        
        guard let doubleDamageFromArr = damageRelations["double_damage_from"] as? [[String: Any]] else {
            print("doubledamagefrom")
            return nil}
        
        var doubleDamageFrom : [NameUrl] = []
        
        doubleDamageFromArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else {
                print("doubledamagefromtemp")
                return}
            doubleDamageFrom.append(temp)
        }
        //double damage to
        guard let doubleDamageToArr = damageRelations["double_damage_to"] as? [[String:Any]] else {
            print("double to")
            return nil}
        var doubleDamageTo : [NameUrl] = []
        doubleDamageToArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else {
                print("double to temp")
                return}
            doubleDamageTo.append(temp)
        }
        
        
        //halfDamageFrom
        guard let halfDamageFromArr = damageRelations["half_damage_from"] as? [[String:Any]] else {
            print("half from")
            return nil}
        var halfDamageFrom : [NameUrl] = []
        halfDamageFromArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else{
                print("half from temp")
                return}
            halfDamageFrom.append(temp)
        }
        //halfDamageTo
        guard let halfDamageToArr = damageRelations["half_damage_to"] as? [[String:Any]] else {
            print("half to")
            return nil}
        var halfDamageTo : [NameUrl] = []
        halfDamageToArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else{
                print("half to temp")
                return}
            halfDamageTo.append(temp)
        }
        //noDamageFrom
        guard let noDamageFromArr = damageRelations["no_damage_from"] as? [[String:Any]] else {
            print("no from")
            return nil}
        var noDamageFrom : [NameUrl] = []
        noDamageFromArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else{
                print("no from temp")
                return}
            noDamageFrom.append(temp)
        }
        //noDamageTo
        guard let noDamageToArr = damageRelations["no_damage_to"] as? [[String:Any]] else{
            print("no to")
            return nil}
        var noDamageTo : [NameUrl] = []
        noDamageToArr.forEach(){
            guard let temp = self.parseNameLink(nameLink: $0) else{
                print("no to temp")
                return}
            noDamageTo.append(temp)
        }
        

        let damage = DamageRelations(doubleDamageFrom: doubleDamageFrom, doubleDamageTo: doubleDamageTo, halfDamageFrom: halfDamageFrom, halfDamageTo: halfDamageTo, noDamageFrom: noDamageFrom, noDamageTo: noDamageTo)
//        print(damage)
        //gameIndices
        guard let gameIndicesArr = base["game_indices"] as? [[String: Any]] else{
            print("gameindices")
            return nil}
        var gameIndices : [GameIndices] = []
        gameIndicesArr.forEach(){
            guard let gameIndex = $0["game_index"] as? Int else{
                print("gameindicesArr")
                return}
            guard let generation = $0["generation"] as? [String:Any] else{
                print("generation")
                return}
            guard let returnGeneration = self.parseNameLink(nameLink: generation) else {
                print("regeneration")
                return}
            gameIndices.append(GameIndices(gameIndex:gameIndex, generation: returnGeneration))
        }
        
        
        // generation
        guard let generation = base["generation"] as? [String: Any]else {
            print("generation")
            return nil}
        guard let rgemeration = self.parseNameLink(nameLink: generation) else{
            print("rgeneration")
            return nil}
//        let
        
        // id
        guard let id = base["id"] as? Int else{
            print("id")
            return nil}
        
        //moveDamageClass
        guard let moveDamageClass = base["move_damage_class"] as? [String : Any] else {
            print("movedamageclass")
            return nil}
        guard let rmoveDamageClass = self.parseNameLink(nameLink:moveDamageClass) else {
            print("rmoveclass")
            return nil }
        
        //moves
        guard let movesArr = base["moves"] as? [[String: Any]]else {
            print("moveArr")
            return nil}
        var moves : [NameUrl] = []
        movesArr.forEach(){
            guard let mo = self.parseNameLink(nameLink: $0) else {return}
            moves.append(mo)
        }
        
        // name
        
        guard let name = base["name"] as? String else{return nil}
        
        // pokemons
        guard let pokemonArr = base["pokemon"] as? [[String:Any]] else{return nil}
        var pokemons :[Pokemon] = []
        pokemonArr.forEach(){
            guard let pokemon = $0["pokemon"] as? [String : Any] else {return}
            guard let poke = self.parseNameLink(nameLink: pokemon) else{return}
            pokemons.append(Pokemon(pokemon: poke))
        }
        
        
                
                
        return Dragon(damageRelations: damage, gameIndices: gameIndices, generation: rgemeration, id: id, moveDamageClass: rmoveDamageClass, moves: moves, name: name, pokemons: pokemons)
    }
    
    private func parseNameLink(nameLink: [String: Any]) -> NameUrl? {
        guard let name = nameLink["name"] as? String else { return nil }
        guard let url = nameLink["url"] as? String else { return nil }
        return NameUrl(name: name, url: url)
    }
    
    
    
}
