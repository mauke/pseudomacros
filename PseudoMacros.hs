{-

Copyright (c) 2013 Lukas Mai

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
* Neither the name of the author nor the names of his contributors
  may be used to endorse or promote products derived from this software
  without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY LUKAS MAI AND CONTRIBUTORS "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-}

-- | The pseudo-macros in this module are meant to be used via Template
-- Haskell (see <http://www.haskell.org/ghc/docs/latest/html/users_guide/template-haskell.html> for more information).
-- 
-- Example:
--
-- > {-# LANGUAGE TemplateHaskell #-}
-- > import PseudoMacros
-- >
-- > main :: IO ()
-- > main = putStrLn ("Hello from " ++ $__FILE__ ++ ", line " ++ show $__LINE__ ++ "!")
--
-- That is, enable the @TemplateHaskell@ extension and put a @$@ before each
-- pseudo-macro.
module PseudoMacros (
    __FILE__,
    __LINE__,
    __MODULE__,
    __PACKAGE__,
    __DATE__,
    __TIME__
) where

import Language.Haskell.TH.Syntax
import Data.Time (formatTime, getZonedTime)
import System.Locale (defaultTimeLocale)

__FILE__, __LINE__ , __MODULE__, __PACKAGE__ :: Q Exp
__FILE__    = lift . loc_filename    =<< location
-- ^ A string containing the current file name.
__LINE__    = lift . fst . loc_start =<< location
-- ^ An integer containing the current line number.
__MODULE__  = lift . loc_module      =<< location
-- ^ A string containing the current module name.
__PACKAGE__ = lift . loc_package     =<< location
-- ^ A string containing the current package name.

__DATE__, __TIME__ :: Q Exp
__DATE__ = lift . formatTime defaultTimeLocale "%Y-%m-%d" =<< runIO getZonedTime
-- ^ A string containing the current date in the format /YYYY-MM-DD/.
__TIME__ = lift . formatTime defaultTimeLocale "%H:%M:%S" =<< runIO getZonedTime
-- ^ A string containing the current time in the format /HH:MM:SS/.
