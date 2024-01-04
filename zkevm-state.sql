\pset pager 0
\d
\l
SHOW config_file
-- select id,status,created_at,updated_at from state.monitored_txs where owner = 'sequencer' order by created_at asc;
-- select * from state.fork_id order by block_num desc limit 5;
-- select * from state.trusted_reorg order by timestamp desc limit 5;
-- select * from state.sync_info limit 5;

-- select * from state.log order by address desc limit 5;
-- select * from state.transaction order by l2_block_num desc limit 5;
-- select * from state.receipt order by block_num desc limit 5;
-- select * from state.l2block order by block_num desc limit 5;
-- select * from state.virtual_batch order by block_num desc limit 5;
-- select * from state.batch order by batch_num desc limit 5;
-- select * from state.proof order by batch_num desc limit 5;
-- select * from state.forced_batch order by timestamp desc limit 5;
-- select * from state.sequences order by from_batch_num desc limit 5;
-- select * from state.block order by block_num desc limit 5;
-- select * from state.verified_batch order by block_num desc limit 5;
-- select * from state.exit_root order by id desc limit 5;

-- select * from state.monitored_txs order by id desc limit 5;

-- SELECT l2b.block_num FROM state.l2block l2b INNER JOIN state.verified_batch vb ON vb.batch_num = l2b.batch_num WHERE l2b.block_num = 1; 
-- SELECT l2b.block_num FROM state.l2block l2b INNER JOIN state.verified_batch vb ON vb.batch_num = l2b.batch_num WHERE l2b.block_num = 2; 
-- SELECT l2b.block_num FROM state.l2block l2b INNER JOIN state.verified_batch vb ON vb.batch_num = l2b.batch_num WHERE l2b.block_num = 3; 
-- SELECT l2b.block_num FROM state.l2block l2b INNER JOIN state.verified_batch vb ON vb.batch_num = l2b.batch_num WHERE l2b.block_num = 4; 
-- SELECT * FROM state.l2block l2b INNER JOIN state.verified_batch vb ON vb.batch_num = l2b.batch_num; 