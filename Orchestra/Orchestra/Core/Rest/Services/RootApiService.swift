//
//  RootApiService.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 28/03/2021.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import RxCocoa

public class RootApiService{
    /// Les fonctions globale de gestion du routing de l'app se fait ici
    
    static var shared = RootApiService()
    
    var ROOT_PATH = "http://" //
    var stringUtils = StringUtils.shared
    var fileUtils = FileUtils.shared

    let disposeBag = DisposeBag()
    var headers: HTTPHeaders = [
        "Content-Type":"application/json",
        "Accept": "application/json"
    ]

    
    init() {
        
    }

}
