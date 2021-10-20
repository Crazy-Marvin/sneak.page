module Main exposing (..)

import Element exposing (Element, alignRight, centerX, centerY, el, fill, height, padding, px, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input


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


red : Element.Color
red =
    Element.rgb255 109 16 56


brightred : Element.Color
brightred =
    Element.rgb255 155 8 71


orange : Element.Color
orange =
    Element.rgb255 247 187 154


startpage : Element msg
startpage =
    Element.column
        [ width fill, Background.color red, height fill ]
        [ header
        , Element.el [ centerX, Font.color orange, Font.medium, Font.size 24, padding 32 ] (Element.text "SHOWING SCREENINGS NEAR")
        , Element.Input.button [ centerX, Font.color orange, Font.medium, Font.size 18, padding 16, Border.width 1, Border.color orange, Border.rounded 4 ]
            { onPress = Nothing
            , label =
                Element.row [ spacing 8 ]
                    [ Element.image [ Element.width (Element.px 22) ]
                        { src = "assets/location_notfixed.svg", description = "Location not provided" }
                    , Element.text "NO LOCATION PROVIDED"
                    ]
            }
        , screenings
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
                    [ Font.color brightred
                    ]
                    (Element.text "SNEAK")
                , Element.el
                    [ Font.color red
                    ]
                    (Element.text ".PAGE")
                ]
            , Element.row [ spacing 30, padding 22, Element.alignRight ]
                [ Element.image [] { src = "assets/account.svg", description = "Account" }
                , Element.image [] { src = "assets/about.svg", description = "About" }
                ]
            ]
        )


screenings =
    Element.row [ spacing 32, centerX, padding 32 ] [ screening, screening, screening, screening ]


screening : Element msg
screening =
    Element.link
        [ centerX, Border.width 1, Border.color orange, Border.rounded 4 ]
        { url = "#"
        , label =
            Element.column []
                [ Element.image [ width (px 256), Border.roundEach { topLeft = 4, topRight = 4, bottomLeft = 0, bottomRight = 0 } ] { src = "assets/upcoming_screening_poster.png", description = "Upcoming Screening" }
                , Element.el [ Font.color orange, Font.size 16, padding 16 ] (Element.text "Upcoming Screening")
                ]
        }


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
