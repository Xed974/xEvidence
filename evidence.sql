CREATE TABLE `evidence` (
  `id` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `pos` varchar(100) NOT NULL,
  `name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `evidence`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `evidence`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;
COMMIT;


--- Xed#1188 | https://discord.gg/HvfAsbgVpM