{-# OPTIONS_GHC -fwarn-incomplete-patterns -Werror #-}

{-| Binary instances for the core datatypes -}
module Idris.Core.Binary where

import Data.Binary
import Data.Vector.Binary
import qualified Data.Text as T

import Idris.Core.TT

instance Binary ErrorReportPart where
  put (TextPart msg) = do putWord8 0 ; put msg
  put (NamePart n) = do putWord8 1 ; put n
  put (TermPart t) = do putWord8 2 ; put t
  put (SubReport ps) = do putWord8 3 ; put ps

  get = do i <- getWord8
           case i of
             0 -> fmap TextPart get
             1 -> fmap NamePart get
             2 -> fmap TermPart get
             3 -> fmap SubReport get
             _ -> error "Corrupted binary data for ErrorReportPart"

instance Binary a => Binary (Err' a) where
  put (Msg str) = do putWord8 0
                     put str
  put (InternalMsg str) = do putWord8 1
                             put str
  put (CantUnify x y z e ctxt i) = do putWord8 2
                                      put x
                                      put y
                                      put z
                                      put e
                                      put ctxt
                                      put i
  put (InfiniteUnify n t ctxt) = do putWord8 3
                                    put n
                                    put t
                                    put ctxt
  put (CantConvert x y ctxt) = do putWord8 4
                                  put x
                                  put y
                                  put ctxt
  put (CantSolveGoal x ctxt) = do putWord8 5
                                  put x
                                  put ctxt
  put (UnifyScope n1 n2 x ctxt) = do putWord8 6
                                     put n1
                                     put n2
                                     put x
                                     put ctxt
  put (CantInferType str) = do putWord8 7
                               put str
  put (NonFunctionType t1 t2) = do putWord8 8
                                   put t1
                                   put t2
  put (NotEquality t1 t2) = do putWord8 9
                               put t1
                               put t2
  put (TooManyArguments n) = do putWord8 10
                                put n
  put (CantIntroduce t) = do putWord8 11
                             put t
  put (NoSuchVariable n) = do putWord8 12
                              put n
  put (NoTypeDecl n) = do putWord8 13
                          put n
  put (NotInjective x y z) = do putWord8 14
                                put x
                                put y
                                put z
  put (CantResolve t) = do putWord8 15
                           put t
  put (CantResolveAlts ns) = do putWord8 16
                                put ns
  put (IncompleteTerm t) = do putWord8 17
                              put t
  put UniverseError = putWord8 18
  put (UniqueError u n) = do putWord8 19
                             put u
                             put n
  put (UniqueKindError u n) = do putWord8 20
                                 put u
                                 put n
  put ProgramLineComment = putWord8 21
  put (Inaccessible n) = do putWord8 22
                            put n
  put (NonCollapsiblePostulate n) = do putWord8 23
                                       put n
  put (AlreadyDefined n) = do putWord8 24
                              put n
  put (ProofSearchFail e) = do putWord8 25
                               put e
  put (NoRewriting t) = do putWord8 26
                           put t
  put (At fc e) = do putWord8 27
                     put fc
                     put e
  put (Elaborating str n e) = do putWord8 28
                                 put str
                                 put n
                                 put e
  put (ElaboratingArg n1 n2 ns e) = do putWord8 29
                                       put n1
                                       put n2
                                       put ns
                                       put e
  put (ProviderError str) = do putWord8 30
                               put str
  put (LoadingFailed str e) = do putWord8 31
                                 put str
                                 put e
  put (ReflectionError parts e) = do putWord8 32
                                     put parts
                                     put e
  put (ReflectionFailed str e) = do putWord8 33
                                    put str
                                    put e

  get = do i <- getWord8
           case i of
             0 -> fmap Msg get
             1 -> fmap InternalMsg get
             2 -> do x <- get ; y <- get ; z <- get ; e <- get ; ctxt <- get ; i <- get
                     return $ CantUnify x y z e ctxt i
             3 -> do x <- get ; y <- get ; z <- get
                     return $ InfiniteUnify x y z
             4 -> do x <- get ; y <- get ; z <- get
                     return $ CantConvert x y z
             5 -> do x <- get ; y <- get
                     return $ CantSolveGoal x y
             6 -> do w <- get ; x <- get ; y <- get ; z <- get
                     return $ UnifyScope w x y z
             7 -> fmap CantInferType get
             8 -> do x <- get ; y <- get
                     return $ NonFunctionType x y
             9 -> do x <- get ; y <- get
                     return $ NotEquality x y
             10 -> fmap TooManyArguments get
             11 -> fmap CantIntroduce get
             12 -> fmap NoSuchVariable get
             13 -> fmap NoTypeDecl get
             14 -> do x <- get ; y <- get ; z <- get
                      return $ NotInjective x y z
             15 -> fmap CantResolve get
             16 -> fmap CantResolveAlts get
             17 -> fmap IncompleteTerm get
             18 -> return UniverseError
             19 -> do x <- get ; y <- get
                      return $ UniqueError x y
             20 -> do x <- get ; y <- get
                      return $ UniqueKindError x y
             21 -> return ProgramLineComment
             22 -> fmap Inaccessible get
             23 -> fmap NonCollapsiblePostulate get
             24 -> fmap AlreadyDefined get
             25 -> fmap ProofSearchFail get
             26 -> fmap NoRewriting get
             27 -> do x <- get ; y <- get
                      return $ At x y
             28 -> do x <- get ; y <- get ; z <- get
                      return $ Elaborating x y z
             29 -> do w <- get ; x <- get ; y <- get ; z <- get
                      return $ ElaboratingArg w x y z
             30 -> fmap ProviderError get
             31 -> do x <- get ; y <- get
                      return $ LoadingFailed x y
             32 -> do x <- get ; y <- get
                      return $ ReflectionError x y
             33 -> do x <- get ; y <- get
                      return $ ReflectionFailed x y
             _ -> error "Corrupted binary data for Err'"
----- Generated by 'derive'

instance Binary FC where
        put (FC x1 (x2, x3) (x4, x5))
          = do put x1
               put (x2 * 65536 + x3)
               put (x4 * 65536 + x5)
        get
          = do x1 <- get
               x2x3 <- get
               x4x5 <- get
               return (FC x1 (x2x3 `div` 65536, x2x3 `mod` 65536) (x4x5 `div` 65536, x4x5 `mod` 65536))


instance Binary Name where
        put x
          = case x of
                UN x1 -> do putWord8 0
                            put x1
                NS x1 x2 -> do putWord8 1
                               put x1
                               put x2
                MN x1 x2 -> do putWord8 2
                               put x1
                               put x2
                NErased -> putWord8 3
                SN x1 -> do putWord8 4
                            put x1
                SymRef x1 -> do putWord8 5
                                put x1
        get
          = do i <- getWord8
               case i of
                   0 -> do x1 <- get
                           return (UN x1)
                   1 -> do x1 <- get
                           x2 <- get
                           return (NS x1 x2)
                   2 -> do x1 <- get
                           x2 <- get
                           return (MN x1 x2)
                   3 -> return NErased
                   4 -> do x1 <- get
                           return (SN x1)
                   5 -> do x1 <- get
                           return (SymRef x1)
                   _ -> error "Corrupted binary data for Name"

instance Binary T.Text where
        put x = put (str x)
        get = do x <- get
                 return (txt x)

instance Binary SpecialName where
        put x
          = case x of
                WhereN x1 x2 x3 -> do putWord8 0
                                      put x1
                                      put x2
                                      put x3
                InstanceN x1 x2 -> do putWord8 1
                                      put x1
                                      put x2
                ParentN x1 x2 -> do putWord8 2
                                    put x1
                                    put x2
                MethodN x1 -> do putWord8 3
                                 put x1
                CaseN x1 -> do putWord8 4; put x1
                ElimN x1 -> do putWord8 5; put x1
                InstanceCtorN x1 -> do putWord8 6; put x1
                WithN x1 x2 -> do putWord8 7
                                  put x1
                                  put x2
        get
          = do i <- getWord8
               case i of
                   0 -> do x1 <- get
                           x2 <- get
                           x3 <- get
                           return (WhereN x1 x2 x3)
                   1 -> do x1 <- get
                           x2 <- get
                           return (InstanceN x1 x2)
                   2 -> do x1 <- get
                           x2 <- get
                           return (ParentN x1 x2)
                   3 -> do x1 <- get
                           return (MethodN x1)
                   4 -> do x1 <- get
                           return (CaseN x1)
                   5 -> do x1 <- get
                           return (ElimN x1)
                   6 -> do x1 <- get
                           return (InstanceCtorN x1)
                   7 -> do x1 <- get
                           x2 <- get
                           return (WithN x1 x2)
                   _ -> error "Corrupted binary data for SpecialName"


instance Binary Const where
        put x
          = case x of
                I x1 -> do putWord8 0
                           put x1
                BI x1 -> do putWord8 1
                            put x1
                Fl x1 -> do putWord8 2
                            put x1
                Ch x1 -> do putWord8 3
                            put x1
                Str x1 -> do putWord8 4
                             put x1
                B8 x1 -> putWord8 5 >> put x1
                B16 x1 -> putWord8 6 >> put x1
                B32 x1 -> putWord8 7 >> put x1
                B64 x1 -> putWord8 8 >> put x1

                (AType (ATInt ITNative)) -> putWord8 9
                (AType (ATInt ITBig)) -> putWord8 10
                (AType ATFloat) -> putWord8 11
                (AType (ATInt ITChar)) -> putWord8 12
                StrType -> putWord8 13
                PtrType -> putWord8 14
                Forgot -> putWord8 15
                (AType (ATInt (ITFixed ity))) -> putWord8 (fromIntegral (16 + fromEnum ity)) -- 16-19 inclusive
                (AType (ATInt (ITVec ity count))) -> do
                        putWord8 20
                        putWord8 (fromIntegral . fromEnum $ ity)
                        putWord8 (fromIntegral count)

                B8V  x1 -> putWord8 21 >> put x1
                B16V x1 -> putWord8 22 >> put x1
                B32V x1 -> putWord8 23 >> put x1
                B64V x1 -> putWord8 24 >> put x1
                BufferType -> putWord8 25
                ManagedPtrType -> putWord8 26
                VoidType -> putWord8 27
        get
          = do i <- getWord8
               case i of
                   0 -> do x1 <- get
                           return (I x1)
                   1 -> do x1 <- get
                           return (BI x1)
                   2 -> do x1 <- get
                           return (Fl x1)
                   3 -> do x1 <- get
                           return (Ch x1)
                   4 -> do x1 <- get
                           return (Str x1)
                   5 -> fmap B8 get
                   6 -> fmap B16 get
                   7 -> fmap B32 get
                   8 -> fmap B64 get

                   9 -> return (AType (ATInt ITNative))
                   10 -> return (AType (ATInt ITBig))
                   11 -> return (AType ATFloat)
                   12 -> return (AType (ATInt ITChar))
                   13 -> return StrType
                   14 -> return PtrType
                   15 -> return Forgot

                   16 -> return (AType (ATInt (ITFixed IT8)))
                   17 -> return (AType (ATInt (ITFixed IT16)))
                   18 -> return (AType (ATInt (ITFixed IT32)))
                   19 -> return (AType (ATInt (ITFixed IT64)))

                   20 -> do
                        e <- getWord8
                        c <- getWord8
                        return (AType (ATInt (ITVec (toEnum . fromIntegral $ e) (fromIntegral c))))

                   21 -> fmap B8V get
                   22 -> fmap B16V get
                   23 -> fmap B32V get
                   24 -> fmap B64V get
                   25 -> return BufferType
                   26 -> return ManagedPtrType
                   27 -> return VoidType
                   _ -> error "Corrupted binary data for Const"


instance Binary Raw where
        put x
          = case x of
                Var x1 -> do putWord8 0
                             put x1
                RBind x1 x2 x3 -> do putWord8 1
                                     put x1
                                     put x2
                                     put x3
                RApp x1 x2 -> do putWord8 2
                                 put x1
                                 put x2
                RType -> putWord8 3
                RConstant x1 -> do putWord8 4
                                   put x1
                RForce x1 -> do putWord8 5
                                put x1
                RUType x1 -> do putWord8 6
                                put x1
        get
          = do i <- getWord8
               case i of
                   0 -> do x1 <- get
                           return (Var x1)
                   1 -> do x1 <- get
                           x2 <- get
                           x3 <- get
                           return (RBind x1 x2 x3)
                   2 -> do x1 <- get
                           x2 <- get
                           return (RApp x1 x2)
                   3 -> return RType
                   4 -> do x1 <- get
                           return (RConstant x1)
                   5 -> do x1 <- get
                           return (RForce x1)
                   6 -> do x1 <- get
                           return (RUType x1)
                   _ -> error "Corrupted binary data for Raw"


instance (Binary b) => Binary (Binder b) where
        put x
          = case x of
                Lam x1 -> do putWord8 0
                             put x1
                Pi x1 x2 -> do putWord8 1
                               put x1
                               put x2
                Let x1 x2 -> do putWord8 2
                                put x1
                                put x2
                NLet x1 x2 -> do putWord8 3
                                 put x1
                                 put x2
                Hole x1 -> do putWord8 4
                              put x1
                GHole x1 x2 -> do putWord8 5
                                  put x1
                                  put x2
                Guess x1 x2 -> do putWord8 6
                                  put x1
                                  put x2
                PVar x1 -> do putWord8 7
                              put x1
                PVTy x1 -> do putWord8 8
                              put x1
        get
          = do i <- getWord8
               case i of
                   0 -> do x1 <- get
                           return (Lam x1)
                   1 -> do x1 <- get
                           x2 <- get
                           return (Pi x1 x2)
                   2 -> do x1 <- get
                           x2 <- get
                           return (Let x1 x2)
                   3 -> do x1 <- get
                           x2 <- get
                           return (NLet x1 x2)
                   4 -> do x1 <- get
                           return (Hole x1)
                   5 -> do x1 <- get
                           x2 <- get
                           return (GHole x1 x2)
                   6 -> do x1 <- get
                           x2 <- get
                           return (Guess x1 x2)
                   7 -> do x1 <- get
                           return (PVar x1)
                   8 -> do x1 <- get
                           return (PVTy x1)
                   _ -> error "Corrupted binary data for Binder"


instance Binary Universe where
        put x = case x of
                     UniqueType -> putWord8 0
                     AllTypes -> putWord8 1
                     NullType -> putWord8 2
        get = do i <- getWord8
                 case i of
                     0 -> return UniqueType
                     1 -> return AllTypes
                     2 -> return NullType
                     _ -> error "Corrupted binary data for Universe"

instance Binary NameType where
        put x
          = case x of
                Bound -> putWord8 0
                Ref -> putWord8 1
                DCon x1 x2 x3 -> do putWord8 2
                                    put (x1 * 65536 + x2)
                                    put x3
                TCon x1 x2 -> do putWord8 3
                                 put (x1 * 65536 + x2)
        get
          = do i <- getWord8
               case i of
                   0 -> return Bound
                   1 -> return Ref
                   2 -> do x1x2 <- get
                           x3 <- get
                           return (DCon (x1x2 `div` 65536) (x1x2 `mod` 65536) x3)
                   3 -> do x1x2 <- get
                           return (TCon (x1x2 `div` 65536) (x1x2 `mod` 65536))
                   _ -> error "Corrupted binary data for NameType"


instance {- (Binary n) => -} Binary (TT Name) where
        put x
          = {-# SCC "putTT" #-}
            case x of
                P x1 x2 x3 -> do putWord8 0
                                 put x1
                                 put x2
--                                  put x3
                V x1 -> if (x1 >= 0 && x1 < 256)
                           then do putWord8 1
                                   putWord8 (toEnum (x1 + 1))
                           else do putWord8 9
                                   put x1
                Bind x1 x2 x3 -> do putWord8 2
                                    put x1
                                    put x2
                                    put x3
                App x1 x2 -> do putWord8 3
                                put x1
                                put x2
                Constant x1 -> do putWord8 4
                                  put x1
                Proj x1 x2 -> do putWord8 5
                                 put x1
                                 putWord8 (toEnum (x2 + 1))
                Erased -> putWord8 6
                TType x1 -> do putWord8 7
                               put x1
                Impossible -> putWord8 8
                UType x1 -> do putWord8 10
                               put x1
        get
          = do i <- getWord8
               case i of
                   0 -> do x1 <- get
                           x2 <- get
--                            x3 <- get
                           return (P x1 x2 Erased)
                   1 -> do x1 <- getWord8
                           return (V ((fromEnum x1) - 1))
                   2 -> do x1 <- get
                           x2 <- get
                           x3 <- get
                           return (Bind x1 x2 x3)
                   3 -> do x1 <- get
                           x2 <- get
                           return (App x1 x2)
                   4 -> do x1 <- get
                           return (Constant x1)
                   5 -> do x1 <- get
                           x2 <- getWord8
                           return (Proj x1 ((fromEnum x2)-1))
                   6 -> return Erased
                   7 -> do x1 <- get
                           return (TType x1)
                   8 -> return Impossible
                   9 -> do x1 <- get
                           return (V x1)
                   10 -> do x1 <- get
                            return (UType x1)
                   _ -> error "Corrupted binary data for TT"

