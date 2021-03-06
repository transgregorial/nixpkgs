{ cabal, comonad, keys, pointed, semigroupoids, semigroups, vector
}:

cabal.mkDerivation (self: {
  pname = "vector-instances";
  version = "3.3";
  sha256 = "0iiw9p2ivcdfsh81vdy4yn6hbigdwclrkssd68hdsg9n6q3fmq5y";
  buildDepends = [
    comonad keys pointed semigroupoids semigroups vector
  ];
  meta = {
    homepage = "http://github.com/ekmett/vector-instances";
    description = "Orphan Instances for 'Data.Vector'";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
