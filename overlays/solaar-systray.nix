# solaar Desktop file patch
# patch solaar Desktop file to fix systray icon and hide on startup

self: super:
{
  solaar = super.solaar.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./solaar-systray.patch
    ];
  });
}
