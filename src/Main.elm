module Main exposing (..)

import Element exposing (Element, alignRight, centerY, el, fill, padding, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


main =
    Element.layout
        [ Font.family
            [ Font.external
                { name = "Work Sans"
                , url = "https://fonts.googleapis.com/css?family=Work+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900"
                }
            , Font.sansSerif
            ]
        ]
        startpage


startpage : Element msg
startpage =
    Element.column
        [ width fill, Background.color (Element.rgb255 109 16 56) ]
        [ header
        , Element.text "Headline"
        , Element.text "LocationInfo"
        , Element.text "Card Grid"
        ]


header : Element msg
header =
    Element.el
        [ width fill
        , Border.shadow
            { offset = ( 0, 7 )
            , size = 0
            , blur = 24
            , color = Element.rgba255 0 0 0 0.19
            }
        ]
        (Element.row
            [ width fill
            , spacing 8
            , padding 8
            , Background.color (Element.rgb255 247 187 154)
            , Border.shadow
                { offset = ( 0, 3 )
                , size = 0
                , blur = 6
                , color = Element.rgba255 0 0 0 0.039
                }
            ]
            --[ Element.explain Debug.todo ]
            [ Element.image [ Element.width (Element.px 64) ]
                { src = "assets/logo.png", description = "Logo" }
            , Element.row
                -- paragraph would break
                [ Font.semiBold
                , Font.size 24
                ]
                [ Element.el
                    [ Font.color (Element.rgb255 155 8 71)
                    ]
                    (Element.text "SNEAK")
                , Element.el
                    [ Font.color (Element.rgb255 109 16 56)
                    ]
                    (Element.text ".PAGE")
                ]
            , Element.row [ spacing 30, padding 22, Element.alignRight ]
                [ Element.image [] { src = "assets/account.svg", description = "Account" }
                , Element.image [] { src = "assets/about.svg", description = "About" }
                ]
            ]
        )


myRowOfStuff : Element msg
myRowOfStuff =
    row [ width fill, centerY, spacing 30 ]
        [ myElement
        , myElement
        , el [ alignRight ] myElement
        ]


myElement : Element msg
myElement =
    el
        [ Background.color (rgb255 240 0 245)
        , Font.color (rgb255 255 255 255)
        , Border.rounded 3
        , padding 30
        ]
        (text "stylish!")
