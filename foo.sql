select
shops.id,
shops.name,
shops.sub_domain,
initial_bulk_linkage_item_summaries.status,
initial_bulk_linkage_item_summaries.linkage_count,
initial_bulk_linkage_item_summaries.success_count,
initial_bulk_linkage_item_summaries.fail_count,
initial_bulk_linkage_item_summaries.not_retry_fail_count,
initial_bulk_linkage_item_summaries.created_at,
initial_bulk_linkage_item_summaries.updated_at
from shops
left join shop_owners on shops.shop_owner_id = shop_owners.id
left join initial_bulk_linkage_item_summaries on shop_owners.id = initial_bulk_linkage_item_summaries.shop_owner_id
where shops.id in (2158,5428,4887)

select
items.id,
item_images.created_at,
item_images.updated_at,
item_images.deleted_at,
shops.name,
shops.sub_domain
from items
left join shops on items.shop_id = shops.id
left join item_images on items.id = item_images.item_id
where shops.id in (2158,5428,4887)


select
items.id,
creema_linkage_items.is_connected,
creema_linkage_items.created_at as creema_linkage_items_created_at,
creema_linkage_items.updated_at as creema_linkage_items_updated_at,
item_images.created_at as item_images_created_at,
item_images.updated_at as item_images_updated_at,
item_images.deleted_at as item_images_deleted_at
from items
left join shops on items.shop_id = shops.id
left join item_images on items.id = item_images.item_id
left join creema_linkage_items on items.id = creema_linkage_items.item_id
where shops.id in (2158,5428,4887)
