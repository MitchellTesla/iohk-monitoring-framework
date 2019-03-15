\subsection{Cardano.BM.Tracer.Class}
\label{code:Cardano.BM.Tracer.Class}

%if style == newcode
\begin{code}
module Cardano.BM.Tracer.Class
    ( Tracer (..)
    , Contravariant(..)
    , nullTracer
    , tracingWith
    ) where

import           Data.Functor.Contravariant (Contravariant (..), Op (..))

\end{code}
%endif

\label{code:Tracer}\index{Tracer}
The notion of a `Tracer` is an action that can be used to observe
information of interest during evaluation. `Tracer`s can capture (and
annotate) such observations with additional information from their
execution context.

\begin{code}
newtype Tracer m s = Tracer { tracing :: Op (m ()) s }
\end{code}

\subsubsection{contramap}\index{BaseTrace!instance of Contravariant}
A `Tracer` is an instance of `Contravariant`, which permits new
`Tracer`s to be constructed that feed into the existing Tracer by use
of `contramap`.

\begin{code}
instance Contravariant (Tracer m) where
    contramap f = Tracer . contramap f . tracing

\end{code}

Although a `Tracer` is invoked in a monadic context (which may be
`Identity`), the construction of a new Tracer is a pure function.

This brings with it the constraint that the derived Tracer's form a
hierachy which has it root at the top level tracer.

\subsubsection{nullTracer}\label{code:nullTracer}\index{nullTracer}
The simplest tracer - one that does not generate output.

\begin{code}
nullTracer :: (Applicative m) => Tracer m a
nullTracer = Tracer $ Op $ \_ -> pure ()

\end{code}

\subsubsection{tracingWith}\label{code:tracingWith}\index{tracingWith}
Accepts a |Tracer| and some payload |s|. First it gets the contravariant
from the |Tracer| as type "|Op (m ()) s|" and, after "|getOp :: b -> a|" which
translates to "|s -> m ()|".

\begin{code}
tracingWith :: Tracer m s -> s -> m ()
tracingWith = getOp . tracing

\end{code}
