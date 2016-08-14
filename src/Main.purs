module Main where

import App.Routes (match)
import App.Layout (Action(PageView), State, view, update) as Lay
import Control.Bind ((=<<))
import Control.Monad.Eff (Eff)
import DOM (DOM)
import Prelude (bind, pure)
import Pux (App, Config, CoreEffects, renderToDOM, start)
import Pux.Devtool (Action, start) as Pux.Devtool
import Pux.Router (sampleUrl)
import Signal ((~>))
import Network.HTTP.Affjax (AJAX)

type AppEffects = (dom :: DOM, ajax :: AJAX)

-- | App configuration
config :: forall eff. Lay.State -> Eff (dom :: DOM | eff) (Config Lay.State Lay.Action AppEffects)
config state = do
  -- | Create a signal of URL changes.
  urlSignal <- sampleUrl

  -- | Map a signal of URL changes to PageView actions.
  let routeSignal = urlSignal ~> \r -> Lay.PageView (match r)

  pure
    { initialState: state
    , update: Lay.update
    , view: Lay.view
    , inputs: [routeSignal] }

-- | Entry point for the browser.
main :: Lay.State -> Eff (CoreEffects AppEffects) (App Lay.State Lay.Action)
main state = do
  app <- start =<< config state
  renderToDOM "#app" app.html
  -- | Used by hot-reloading code in support/index.js
  pure app

-- | Entry point for the browser with pux-devtool injected.
debug :: Lay.State -> Eff (CoreEffects AppEffects) (App Lay.State (Pux.Devtool.Action Lay.Action))
debug state = do
  app <- Pux.Devtool.start =<< config state
  renderToDOM "#app" app.html
  -- | Used by hot-reloading code in support/index.js
  pure app
