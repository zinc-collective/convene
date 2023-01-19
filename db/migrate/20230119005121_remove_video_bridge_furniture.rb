class RemoveVideoBridgeFurniture < ActiveRecord::Migration[7.0]
  # As of 2023/1/28, these are the video-bridge placements in production
  # > FurniturePlacement.where(furniture_kind: "video_bridge").map {|fp| [fp.id, fp.room.slug, fp.room.space.slug]}
  # [["c868b70f-00a8-4889-92fb-8a39106a507d", "zee-s-desk", "convene-demo"],
  # ["be167a5b-628c-4366-b191-d8804813b77c", "vivek-s-desk", "convene-demo"],
  # ["d9196ae8-9fe6-4bfd-875b-3e593411fed4", "water-cooler", "convene-demo"],
  # ["4e2116fc-eb4c-4466-b269-b5cd0da8f1f2", "the-ada-lovelace-room",
  # "convene-demo"], ["ca5ea9f3-1680-4528-ae4b-b13ce499cdf3", "locked-room",
  # "convene-demo"], ["eaa117fc-2326-4903-9cfd-92e68d0ed38d", "viveks-desk",
  # "avigno"], ["402a54c6-513f-4d35-a416-b0e9089f72bb", "music-room", "avigno"],
  # ["fd1a0b4c-973b-4078-a2eb-5b45f7b89731", "common-room", "avigno"]]
  def up
    FurniturePlacement.where(furniture_kind: "video_bridge").destroy_all
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
