-- If you have migrated your Citavi database from an on-premise server to SQL Azure, 
-- some permissions may be lost. Run these statements to restore them.

-- CAUTION: Please uninstall and install the FullText Search via DBServer Manager.
-- Afterwards, open every DBServer project once in the Citavi client to start re-indexing.

-- Please contact our support for more information.



grant select on schema::Citavi6 to [public];
grant execute on schema::Citavi6 to [public];
grant insert on Citavi6.ProjectUser TO [public];
grant update on Citavi6.ProjectUser TO [public];
grant delete on Citavi6.ProjectUser TO [public];


grant insert on Citavi6.Settings TO [Citavi Settings Admin] with grant option;
grant update on Citavi6.Settings TO [Citavi Settings Admin] with grant option;
grant delete on Citavi6.Settings TO [Citavi Settings Admin] with grant option;

grant insert on Citavi6.CitaviUser TO [Citavi Project Creator] with grant option;
grant update on Citavi6.CitaviUser TO [Citavi Project Creator] with grant option;
grant delete on Citavi6.CitaviUser TO [Citavi Project Creator] with grant option;

grant insert on Citavi6.CitaviUser TO [Citavi User Manager] with grant option;
grant update on Citavi6.CitaviUser TO [Citavi User Manager] with grant option;
grant delete on Citavi6.CitaviUser TO [Citavi User Manager] with grant option;
