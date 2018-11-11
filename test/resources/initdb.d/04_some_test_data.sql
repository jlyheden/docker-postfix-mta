INSERT INTO `mailserver`.`virtual_domains`
  (`id` ,`name`)
VALUES
  ('1', 'example.com'),
  ('2', 'mx.example.com');

INSERT INTO `mailserver`.`virtual_users`
  (`id`, `domain_id`, `password` , `email`, `username`)
VALUES
  ('1', '1', 'doesntmatter', 'john.doe@example.com', 'john.doe');

INSERT INTO `mailserver`.`virtual_aliases`
  (`id`, `domain_id`, `source`, `destination`)
VALUES
  ('1', '1', 'alias1-john.doe@example.com', 'john.doe@example.com'),
  ('2', '1', 'alias2-john.doe@example.com', 'john.doe@example.com');