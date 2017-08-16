//
//  BlackButton.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

public class BlackButton: BaseButton {

    override func stylize() {
        super.stylize(textColor: theme.whiteColor, backgroundColor: theme.blackColor, borderColor: theme.borderColor)
    }
}
