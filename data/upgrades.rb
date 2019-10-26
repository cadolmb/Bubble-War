module Upgrades

    DAMAGE_START_VALUE = 1
    PLAYER_HEALTH_START_VALUE = 3
    BULLET_SPEED_START_VALUE = 10
    BULLET_WIDTH_START_VALUE = 20
    BULLET_PENETRATION_START_VALUE = 1
    DOUBLE_SHOT_START_VALUE = false

    DAMAGE_UPGRADE = 1
    PLAYER_HEALTH_UPGRADE = 1
    BULLET_SPEED_UPGRADE = 1
    BULLET_WIDTH_UPGRADE = 2
    BULLET_PENETRATION_UPGRADE = 1
    DOUBLE_SHOT_UPGRADE = true

    DAMAGE_MAX = 5
    PLAYER_HEALTH_MAX = 5
    BULLET_SPEED_MAX = 20
    BULLET_WIDTH_MAX = 50
    BULLET_PENETRATION_MAX = 5
    DOUBLE_SHOT_MAX = true

    @@damage = DAMAGE_START_VALUE
    @@player_health = PLAYER_HEALTH_START_VALUE
    @@bullet_speed = BULLET_SPEED_START_VALUE
    @@bullet_width = BULLET_WIDTH_START_VALUE
    @@bullet_penetration = BULLET_PENETRATION_START_VALUE
    @@double_shot = DOUBLE_SHOT_START_VALUE

    def self.stats
        {
            "Damage" => @@damage,
            "Health" => @@player_health,
            "Bullet Speed" => @@bullet_speed,
            "Bullet Size" => @@bullet_width,
            "Bullet Piercing" => @@bullet_penetration,
            "Double Shot" => @@double_shot
        }
    end

    def self.upgrades
        {
            "Damage" => DAMAGE_UPGRADE,
            "Health" => PLAYER_HEALTH_UPGRADE,
            "Bullet Speed" => BULLET_SPEED_UPGRADE,
            "Bullet Size" => BULLET_WIDTH_UPGRADE,
            "Bullet Piercing" => BULLET_PENETRATION_UPGRADE,
            "Double Shot" => DOUBLE_SHOT_UPGRADE
        }
    end

    def self.upgrade_max
        {
            "Damage" => DAMAGE_MAX,
            "Health" => PLAYER_HEALTH_MAX,
            "Bullet Speed" => BULLET_SPEED_MAX,
            "Bullet Size" => BULLET_WIDTH_MAX,
            "Bullet Piercing" => BULLET_PENETRATION_MAX,
            "Double Shot" => DOUBLE_SHOT_MAX
        }
    end

    def self.set(stats)
        @@damage = stats["Damage"]
        @@player_health = stats["Health"]
        @@bullet_speed = stats["Bullet Speed"]
        @@bullet_width = stats["Bullet Size"]
        @@bullet_penetration = stats["Bullet Piercing"]
        @@double_shot = stats["Double Shot"]
    end

    def self.upgrade(stat, value)
        stats = self.stats
        max = self.upgrade_max
        changed = false
        if value.is_a? Integer
            unless stats[stat] >= max[stat]
                stats[stat] += value
                changed = true
            end
        else
            unless stats[stat] == value
                stats[stat] = value
                changed = true
            end
        end
        self.set(stats)
        changed
    end

    def self.reset
        @@damage = DAMAGE_START_VALUE
        @@player_health = PLAYER_HEALTH_START_VALUE
        @@bullet_speed = BULLET_SPEED_START_VALUE
        @@bullet_width = BULLET_WIDTH_START_VALUE
        @@bullet_penetration = BULLET_PENETRATION_START_VALUE
        @@double_shot = DOUBLE_SHOT_START_VALUE
    end
end
