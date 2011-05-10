-- 获取所有顶层单位信息
explain select m.* from BC_IDENTITY_ACTOR m where m.type_ =2 and m.id not in 
(select f.id from BC_IDENTITY_ACTOR f inner join BC_IDENTITY_ACTOR_RELATION ar on f.id=ar.follower_id where f.type_=2 and ar.type_=0);

-- 获取单位的下属单位或部门信息
explain select m1.name,f1.* from BC_IDENTITY_ACTOR f1
inner join BC_IDENTITY_ACTOR_RELATION ar1 on ar1.follower_id=f1.id
inner join BC_IDENTITY_ACTOR m1 on m1.id=ar1.master_id
where (f1.type_ =2) and ar1.type_=0 and m1.id in (
  select m.id from BC_IDENTITY_ACTOR m where m.type_=2 and m.id not in 
    (select f.id from BC_IDENTITY_ACTOR f inner join BC_IDENTITY_ACTOR_RELATION ar on f.id=ar.follower_id where f.type_=2 and ar.type_=0)
) order by f1.code;

-- 获取单位的下属部门信息
explain select m1.name,f1.* from BC_IDENTITY_ACTOR f1
inner join BC_IDENTITY_ACTOR_RELATION ar1 on ar1.follower_id=f1.id
inner join BC_IDENTITY_ACTOR m1 on m1.id=ar1.master_id
where (f1.type_ =3) and ar1.type_=0 and m1.id in (
  select m.id from BC_IDENTITY_ACTOR m where m.type_=2 and m.id not in 
    (select f.id from BC_IDENTITY_ACTOR f inner join BC_IDENTITY_ACTOR_RELATION ar on f.id=ar.follower_id where f.type_=2 and ar.type_=0)
) order by f1.code;

-- 使用in在mysql中会导致全表查询
explain select f.* from BC_IDENTITY_ACTOR f where f.type_ in(2,3);
explain (select f1.* from BC_IDENTITY_ACTOR f1 where f1.type_ =2) union all (select f1.* from BC_IDENTITY_ACTOR f1 where f1.type_ =3);