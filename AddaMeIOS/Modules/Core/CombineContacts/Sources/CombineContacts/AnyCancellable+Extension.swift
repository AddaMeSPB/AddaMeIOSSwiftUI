//
//  AnyCancellable+Extension.swift
//  
//
//  Created by Saroar Khandoker on 25.03.2021.
//

import Combine

extension AnyCancellable {
  public static var empty: AnyCancellable {
    AnyCancellable { }
  }
}
