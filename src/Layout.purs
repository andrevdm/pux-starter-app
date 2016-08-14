module App.Layout where

import DOM (DOM)
import App.Counter as Counter
import App.NotFound as NotFound
import App.Routes (Route(Home, NotFound))
import Prelude (($), (#), map)
import Pux (noEffects, EffModel, mapState, mapEffects)
import Pux.Html (Html, div, h1, p, text, hr)
import Network.HTTP.Affjax (AJAX)

data Action
  = PostCounter (Counter.Action)
  | PostCounter2 (Counter.Action)
  | PageView Route

type State =
  { route :: Route
  , count :: Counter.State
  , count2 :: Counter.State
  }

init :: State
init =
  {
    route: NotFound
  , count: Counter.init
  , count2: Counter.init
  }

update :: Action -> State -> EffModel State Action (dom :: DOM, ajax :: AJAX)
update (PageView route) state = noEffects $ state { route = route }
update (PostCounter action) state =
  Counter.update action state.count
  # mapState (state {count = _}) 
  # mapEffects PostCounter 
update (PostCounter2 action) state =
  Counter.update action state.count2
  # mapState (state {count2 = _}) 
  # mapEffects PostCounter2 

view :: State -> Html Action
view state =
  div
    []
    [ h1 [] [ text "Pux Starter App" ]
    , p [] [ text "Change src/Layout.purs and watch me hot-reload." ]
    , case state.route of
        Home ->
          div
            []
            [
              map PostCounter $ Counter.view state.count
            , hr [] [] 
            , map PostCounter2 $ Counter.view state.count2
            ]
        NotFound -> NotFound.view state
    ]
