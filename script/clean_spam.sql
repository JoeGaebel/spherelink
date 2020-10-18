select * from users left join memories on memories.user_id = users.id where memories.id is null;

DELETE from users
WHERE users.id in (
  select users.id
  from users
  left join memories
  on memories.user_id = users.id
  where memories.id is null;
)
