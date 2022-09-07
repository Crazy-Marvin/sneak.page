module Main exposing (..)

import Browser
import Dict
import Element exposing (Element, alignRight, centerX, centerY, el, fill, height, padding, px, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input
import Html exposing (Html)
import Http
import Json.Decode
import List.Extra
import Sentry exposing (Sentry)
import Task
import UUID exposing (UUID)


type alias Model =
    { pastScreenings : List PastScreening }


type alias PastScreening =
    { id : String
    , createdAt : String
    , movieId : Int
    , cinemaId : String
    , screenedAt : String
    }


pastScreeningDecoder : Json.Decode.Decoder PastScreening
pastScreeningDecoder =
    Json.Decode.map5
        (\id createdAt movieId cinemaId screenedAt ->
            { id = id
            , createdAt = createdAt
            , movieId = movieId
            , cinemaId = cinemaId
            , screenedAt = screenedAt
            }
        )
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "created_at" Json.Decode.string)
        (Json.Decode.field "movie_id" Json.Decode.int)
        (Json.Decode.field "cinema_id" Json.Decode.string)
        (Json.Decode.field "screened_at" Json.Decode.string)


type Msg
    = PastScreeningsReceived
        -- Pascal case for all type definitions
        (Result Http.Error (List PastScreening))
    | Response (Result Http.Error UUID)


main : Program {} Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : {} -> ( Model, Cmd Msg )
init flags =
    ( { pastScreenings = [] }
    , Cmd.batch
        [ Http.request
            { method = "GET"
            , headers =
                [ Http.header "apikey" "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmdnpweWp3bXZiZGdkc3ppcXlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDQ0NDYyNzksImV4cCI6MTk2MDAyMjI3OX0.6Qr5tFLT0tO0vvxlpIr5t22365GkKRGwqjgKRVQc1Po"
                , Http.header "Authorization" "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmdnpweWp3bXZiZGdkc3ppcXlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDQ0NDYyNzksImV4cCI6MTk2MDAyMjI3OX0.6Qr5tFLT0tO0vvxlpIr5t22365GkKRGwqjgKRVQc1Po"
                ]
            , url = "https://hfvzpyjwmvbdgdsziqyj.supabase.co/rest/v1/past_screenings"
            , body = Http.emptyBody
            , expect = Http.expectJson PastScreeningsReceived pastScreeningsDecoder
            , timeout = Nothing
            , tracker = Nothing
            }
        , case moviesOrError of
            Err decodeError ->
                Task.attempt Response (sentry.debug "moviesError" Dict.empty)

            Ok movies ->
                Cmd.none

        -- it does not matter if Err or Ok first
        ]
    )


pastScreeningsDecoder : Json.Decode.Decoder (List PastScreening)
pastScreeningsDecoder =
    Json.Decode.list pastScreeningDecoder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PastScreeningsReceived (Ok newPastScreenings) ->
            ( { model | pastScreenings = newPastScreenings }, Cmd.none )

        PastScreeningsReceived (Err httpError) ->
            let
                _ =
                    Debug.log "httpError" httpError
            in
            ( model, Task.attempt Response (sentry.debug "httpError" Dict.empty) )

        Response _ ->
            -- ignore
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    Element.layout
        [ Font.family
            [ Font.external
                { name = "Work Sans"
                , url = "https://fonts.googleapis.com/css?family=Work+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900"
                }
            , Font.sansSerif
            ]
        ]
        (startpage model)


red : Element.Color
red =
    Element.rgb255 109 16 56


brightred : Element.Color
brightred =
    Element.rgb255 155 8 71


orange : Element.Color
orange =
    Element.rgb255 247 187 154


startpage : Model -> Element msg
startpage model =
    Element.column
        [ width fill, Background.color red, height fill ]
        [ Element.text (String.fromInt (List.length model.pastScreenings))
        , header
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
        , case moviesOrError of
            Ok movies ->
                screenings movies

            Err error ->
                Element.text (Json.Decode.errorToString error)
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


screenings : List Movie -> Element msg
screenings movies =
    Element.column
        [ spacing 32
        , centerX
        , padding 32

        -- , Element.explain Debug.todo
        ]
        (List.map (Element.row [ spacing 32 ])
            (List.Extra.greedyGroupsOf 4 (List.map screening movies))
        )


screening : Movie -> Element msg
screening movie =
    Element.link
        [ Border.width 1
        , Border.color orange
        , Border.rounded 4
        , width (px 256)
        , height fill
        ]
        { url = "#"
        , label =
            Element.column [ height fill ]
                [ Element.image
                    [ width fill
                    , Border.roundEach
                        { topLeft = 4
                        , topRight = 4
                        , bottomLeft = 0
                        , bottomRight = 0
                        }
                    ]
                    { src = "assets/upcoming_screening_poster.png"
                    , description = "Upcoming Screening"
                    }
                , Element.el
                    [ Font.color orange
                    , Font.size 16
                    , padding 16
                    ]
                    (Element.paragraph [ Element.width Element.fill ]
                        [ Element.text movie.originalTitle ]
                    )
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


jsonData : String
jsonData =
    """{"dates":{"maximum":"2022-01-06","minimum":"2021-12-14"},"page":1,"results":[{"adult":false,"backdrop_path":"/VlHt27nCqOuTnuX6bku8QZapzO.jpg","genre_ids":[28,12,878,14],"id":634649,"original_language":"en","original_title":"Spider-Man: No Way Home","overview":"Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero. When he asks for help from Doctor Strange the stakes become even more dangerous, forcing him to discover what it truly means to be Spider-Man.","popularity":4062.446,"poster_path":"/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg","release_date":"2021-12-15","title":"Spider-Man: No Way Home","video":false,"vote_average":8.4,"vote_count":84},{"adult":false,"backdrop_path":"/gSq4IvnsMKJQf0FaKn9bDE2Sggq.jpg","genre_ids":[16,35,10751],"id":585245,"original_language":"en","original_title":"Clifford the Big Red Dog","overview":"As Emily struggles to fit in at home and at school, she discovers a small red puppy who is destined to become her best friend. When Clifford magically undergoes one heck of a growth spurt, becomes a gigantic dog and attracts the attention of a genetics company, Emily and her Uncle Casey have to fight the forces of greed as they go on the run across New York City. Along the way, Clifford affects the lives of everyone around him and teaches Emily and her uncle the true meaning of acceptance and unconditional love.","popularity":2509.512,"poster_path":"/ygPTrycbMSFDc5zUpy4K5ZZtQSC.jpg","release_date":"2021-11-10","title":"Clifford the Big Red Dog","video":false,"vote_average":7.6,"vote_count":568},{"adult":false,"backdrop_path":"/r2GAjd4rNOHJh6i6Y0FntmYuPQW.jpg","genre_ids":[12,28,53],"id":370172,"original_language":"en","original_title":"No Time to Die","overview":"Bond has left active service and is enjoying a tranquil life in Jamaica. His peace is short-lived when his old friend Felix Leiter from the CIA turns up asking for help. The mission to rescue a kidnapped scientist turns out to be far more treacherous than expected, leading Bond onto the trail of a mysterious villain armed with dangerous new technology.","popularity":1474.837,"poster_path":"/iUgygt3fscRoKWCV1d0C7FbM9TP.jpg","release_date":"2021-09-29","title":"No Time to Die","video":false,"vote_average":7.6,"vote_count":2543},{"adult":false,"backdrop_path":"/4gKxQIW91hOTELjY5lzjMbLoGxB.jpg","genre_ids":[28,53,878],"id":763164,"original_language":"en","original_title":"Apex","overview":"Ex-cop Thomas Malone is serving a life sentence for a crime he didn’t commit. He is offered a chance at freedom if he can survive a deadly game of Apex, in which six hunters pay for the pleasure of hunting another human on a remote island. He accepts, and once he arrives, all hell breaks loose.","popularity":805.068,"poster_path":"/chTkFGToW5bsyw3hgLAe4S5Gt3.jpg","release_date":"2021-11-12","title":"Apex","video":false,"vote_average":5.5,"vote_count":276},{"adult":false,"backdrop_path":"/9OE62lhp5FPNJMfKXodegVLjHUA.jpg","genre_ids":[16,10751],"id":823609,"original_language":"en","original_title":"Monster Family 2","overview":"To free Baba Yaga and Renfield from the clutches of Monster Hunter Mila Starr, the Wishbone Family once more transforms into a Vampire, Frankenstein's Monster, a Mummy and a Werewolf. Aided and abetted by their three pet bats, our Monster Family zooms around the world again to save their friends, make new monstrous acquaintances and finally come to the realization that ‘Nobody’s Perfect’ – even those with flaws can find happiness.","popularity":479.85,"poster_path":"/em2NLSbVj49NjpdqmaKYuqKYZET.jpg","release_date":"2021-01-13","title":"Monster Family 2","video":false,"vote_average":7.6,"vote_count":16},{"adult":false,"backdrop_path":"/wfrfxivLOBtGMC98tIr2LSOeKSe.jpg","genre_ids":[16,12,35,10751],"id":639721,"original_language":"en","original_title":"The Addams Family 2","overview":"The Addams get tangled up in more wacky adventures and find themselves involved in hilarious run-ins with all sorts of unsuspecting characters.","popularity":463.087,"poster_path":"/ld7YB9vBRp1GM1DT3KmFWSmtBPB.jpg","release_date":"2021-10-01","title":"The Addams Family 2","video":false,"vote_average":7.3,"vote_count":638},{"adult":false,"backdrop_path":"/cDVWsqsnGwIUqOSzAuDS0PIhNdW.jpg","genre_ids":[18,10749,10402],"id":424277,"original_language":"en","original_title":"Annette","overview":"The story of Henry, a stand-up comedian with a fierce sense of humour and Ann, a singer of international renown. In the spotlight, they are the perfect couple, healthy, happy, and glamourous. The birth of their first child, Annette, a mysterious girl with an exceptional destiny, will change their lives.","popularity":455.949,"poster_path":"/4FTnypxpGltJdIARrfFsP31pGTp.jpg","release_date":"2021-07-06","title":"Annette","video":false,"vote_average":7.1,"vote_count":295},{"adult":false,"backdrop_path":"/tutaKitJJIaqZPyMz7rxrhb4Yxm.jpg","genre_ids":[16,35,10751,10402],"id":438695,"original_language":"en","original_title":"Sing 2","overview":"Buster and his new cast now have their sights set on debuting a new show at the Crystal Tower Theater in glamorous Redshore City. But with no connections, he and his singers must sneak into the Crystal Entertainment offices, run by the ruthless wolf mogul Jimmy Crystal, where the gang pitches the ridiculous idea of casting the lion rock legend Clay Calloway in their show. Buster must embark on a quest to find the now-isolated Clay and persuade him to return to the stage.","popularity":454.919,"poster_path":"/aWeKITRFbbwY8txG5uCj4rMCfSP.jpg","release_date":"2021-12-01","title":"Sing 2","video":false,"vote_average":7.8,"vote_count":26},{"adult":false,"backdrop_path":"/qknLmBKDyjGMC40b7ZehqdfIi2A.jpg","genre_ids":[35,14,12,878],"id":425909,"original_language":"en","original_title":"Ghostbusters: Afterlife","overview":"When a single mom and her two kids arrive in a small town, they begin to discover their connection to the original Ghostbusters and the secret legacy their grandfather left behind.","popularity":351.471,"poster_path":"/kHNWm8YDl1Pf6tyzluLagbtkU94.jpg","release_date":"2021-11-11","title":"Ghostbusters: Afterlife","video":false,"vote_average":7.3,"vote_count":307},{"adult":false,"backdrop_path":"/3NiiRAKt2L5bUuAvSOkv6Yn7u6T.jpg","genre_ids":[28,12,878],"id":624860,"original_language":"en","original_title":"The Matrix Resurrections","overview":"Plagued by strange memories, Neo's life takes an unexpected turn when he finds himself back inside the Matrix.","popularity":282.839,"poster_path":"/xLNtaLaHudIzOqdEZ7R3lcDLrQQ.jpg","release_date":"2021-12-16","title":"The Matrix Resurrections","video":false,"vote_average":8.9,"vote_count":11},{"adult":false,"backdrop_path":"/6UxCO59sdhvp43OCkrYx4EX61J.jpg","genre_ids":[18],"id":766798,"original_language":"es","original_title":"Madres paralelas","overview":"Two unmarried women who have become pregnant by accident and are about to give birth meet in a hospital room: Janis, middle-aged, unrepentant and happy; Ana, a teenager, remorseful and frightened.","popularity":266.479,"poster_path":"/gDaxYkYNbHuM2VlUazbcpnFZB6d.jpg","release_date":"2021-10-08","title":"Parallel Mothers","video":false,"vote_average":6.8,"vote_count":145},{"adult":false,"backdrop_path":"/jdLsmpqmP1wTdFUPtmxMnYgoifT.jpg","genre_ids":[18,80,53],"id":644495,"original_language":"en","original_title":"House of Gucci","overview":"When Patrizia Reggiani, an outsider from humble beginnings, marries into the Gucci family, her unbridled ambition begins to unravel the family legacy and triggers a reckless spiral of betrayal, decadence, revenge, and ultimately…murder.","popularity":213.766,"poster_path":"/cy6fvTf9YqehVhReYnm5cc3GqhZ.jpg","release_date":"2021-11-24","title":"House of Gucci","video":false,"vote_average":6.9,"vote_count":299},{"adult":false,"backdrop_path":"/wPjtacig0kIkVcTQmXoNt6jbMwo.jpg","genre_ids":[28,35],"id":617502,"original_language":"en","original_title":"Jolt","overview":"Lindy is an acid-tongued woman with rage issues who controls her temper by shocking herself with an electrode vest. One day she makes a connection with Justin, who gives her a glimmer of hope for a shock-free future, but when he’s murdered she launches herself on a revenge-fueled rampage in pursuit of his killer.","popularity":182.334,"poster_path":"/gYZAHan5CHPFXORpQMvOjCTug4E.jpg","release_date":"2021-07-15","title":"Jolt","video":false,"vote_average":6.8,"vote_count":790},{"adult":false,"backdrop_path":"/ovggmAOu1IbPGTQE8lg4lBasNC7.jpg","genre_ids":[878],"id":412656,"original_language":"en","original_title":"Chaos Walking","overview":"Two unlikely companions embark on a perilous adventure through the badlands of an unexplored planet as they try to escape a dangerous and disorienting reality, where all inner thoughts are seen and heard by everyone.","popularity":117.179,"poster_path":"/9kg73Mg8WJKlB9Y2SAJzeDKAnuB.jpg","release_date":"2021-02-24","title":"Chaos Walking","video":false,"vote_average":6.8,"vote_count":1420},{"adult":false,"backdrop_path":"/g8dafKwLfaueQ5GK0qjKTkRCBAA.jpg","genre_ids":[99],"id":899082,"original_language":"en","original_title":"Harry Potter 20th Anniversary: Return to Hogwarts","overview":"An enchanting making-of story told through all-new in-depth interviews and cast conversations, inviting fans on a magical first-person journey through one of the most beloved film franchises of all time.","popularity":113.395,"poster_path":"/9vcy1wePRaoPKPqWEg0sEAfvOtA.jpg","release_date":"2022-01-01","title":"Harry Potter 20th Anniversary: Return to Hogwarts","video":false,"vote_average":0,"vote_count":0},{"adult":false,"backdrop_path":"/9fzNf2QcsHVvdx5g5QUOgAWpADw.jpg","genre_ids":[27,9648],"id":516329,"original_language":"en","original_title":"Antlers","overview":"A young teacher discovers that her troubled student's father and younger brother harbor a deadly supernatural secret. Taking the boy into her care, the teacher must fight for their survival against horrors beyond imagination.","popularity":89.152,"poster_path":"/klsDRXM68wV7vZTTaAOuu62VNA1.jpg","release_date":"2021-10-28","title":"Antlers","video":false,"vote_average":6.2,"vote_count":85},{"adult":false,"backdrop_path":"/r4VQbiydjDH7ULo1HWjkkrNt3da.jpg","genre_ids":[10749,18,80],"id":511809,"original_language":"en","original_title":"West Side Story","overview":"Two youngsters from rival New York City gangs fall in love, but tensions between their respective friends build toward tragedy.","popularity":82.496,"poster_path":"/zeAZTPxV5xZRNEX3rZotnsp7IVo.jpg","release_date":"2021-12-08","title":"West Side Story","video":false,"vote_average":7.5,"vote_count":81},{"adult":false,"backdrop_path":"/x3UVh44oov4LGkAg2zVFXoPeYra.jpg","genre_ids":[18,53,27],"id":630240,"original_language":"fr","original_title":"Titane","overview":"A woman with a metal plate in her head from a childhood car accident embarks on a bizarre journey, bringing her into contact with a firefighter who's reunited with his missing son after 10 years.","popularity":71.278,"poster_path":"/AeQC4gFwkIvjAwnSd2RPAlgs1VE.jpg","release_date":"2021-07-14","title":"Titane","video":false,"vote_average":6.6,"vote_count":410},{"adult":false,"backdrop_path":"/4OTYefcAlaShn6TGVK33UxLW9R7.jpg","genre_ids":[28,12,53],"id":476669,"original_language":"en","original_title":"The King's Man","overview":"As a collection of history's worst tyrants and criminal masterminds gather to plot a war to wipe out millions, one man must race against time to stop them.","popularity":70.188,"poster_path":"/nj5HmHRZsrYQEYYXyAusFv35erP.jpg","release_date":"2021-12-21","title":"The King's Man","video":false,"vote_average":0,"vote_count":0},{"adult":false,"backdrop_path":"/2nU5H8XIgtMkJrxsryP6nJuAHQ.jpg","genre_ids":[16,18,12,10751],"id":805051,"original_language":"en","original_title":"Smelliville","overview":"The Oggly family arrive at the municipal rubbish dump of Smelliville and must look for a new home, but they never feel really welcome anywhere. They stink and are for most humans just a tad too oggly. When Firebottom, the family dragon, crash-lands on the run-down rubbish tip of the small town of Smelliville, the Ogglies at once feel at home. And it's here they want to stay.","popularity":66.33,"poster_path":"/w7PJ7fBEYOuaAMKfYa4zmw45v3N.jpg","release_date":"2021-01-01","title":"The Ogglies: Welcome to Smelliville","video":false,"vote_average":7.5,"vote_count":34}],"total_pages":40,"total_results":791}"""


type alias Movie =
    { originalTitle : String
    , overview : String
    }


movieDecoder : Json.Decode.Decoder Movie
movieDecoder =
    -- Movie is a short form for the anonymous function \x -> {originalTitle = x}
    Json.Decode.map2
        (\x y ->
            { originalTitle = x
            , overview = y
            }
        )
        (Json.Decode.field "original_title" Json.Decode.string)
        (Json.Decode.field "overview" Json.Decode.string)


moviesOrError : Result Json.Decode.Error (List Movie)
moviesOrError =
    Json.Decode.decodeString (Json.Decode.field "results" (Json.Decode.list movieDecoder)) jsonData



-- SENTRY


{-| DSN: <https://0bde8933d4a94a6dba12eddeed97a36e@o282785.ingest.sentry.io/6606204>
-}
config : Sentry.Config
config =
    Sentry.config
        { publicKey = "0bde8933d4a94a6dba12eddeed97a36e"
        , host = "o282785.ingest.sentry.io"
        , projectId = "6606204"
        }


releaseVersion : Sentry.ReleaseVersion
releaseVersion =
    Sentry.releaseVersion "1.0.0"


environment : Sentry.Environment
environment =
    Sentry.environment "test"


sentry : Sentry
sentry =
    Sentry.withContext config releaseVersion environment "example"
