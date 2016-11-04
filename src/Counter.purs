module App.Counter where

import Prelude (const, show, negate, pure, ($), (+))
import Pux (noEffects, EffModel)
import Pux.Html (Html, div, span, button, text)
import Pux.Html.Events (onClick)
import Network.HTTP.Affjax (AJAX)
import DOM (DOM)

data Action = Increment | Decrement | ReceiveInc Int

type State = Int

init :: State
init = 0

update :: Action -> State -> EffModel State Action (dom :: DOM, ajax :: AJAX)
update (ReceiveInc i) state= 
  noEffects $ state + i
update Increment state =
  { state: state
  , effects: [ do
                  pure $ ReceiveInc 1
             ]
  }
update Decrement state =
  { state: state
  , effects: [ do
                  pure $ ReceiveInc (-1)
             ]
  }

view :: State -> Html Action
view state =
  div
    []
    [ button [ onClick (const Increment) ] [ text "Increment" ]
    , span [] [ text (show state) ]
    , button [ onClick (const Decrement) ] [ text "Decrement" ]
    ]
