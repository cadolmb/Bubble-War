module Collision

  def Collision.circle(a, b)
    return Gosu.distance(a.x, a.y, b.x, b.y) < a.rad + b.rad
  end

  def Collision.player_enemy(p, c)
    return false unless Gosu.distance(p.x, p.y, c.x, c.y) < c.rad + p.width

    collide = false
    p.coll_points.each do |v|
      x = p.x + (v[0] - p.width/2) * Math.cos(p.angle*(Math::PI/180)) - (v[1] - p.height/2) * Math.sin(p.angle*(Math::PI/180))
      y = p.y + (v[0] - p.width/2) * Math.sin(p.angle*(Math::PI/180)) + (v[1] - p.height/2) * Math.cos(p.angle*(Math::PI/180))

      collide = Gosu.distance(x, y, c.x, c.y) < c.rad || collide
    end
    return collide
  end

  def Collision.player_star(p, s)
    return Gosu.distance(p.x, p.y, s.x, s.y) < s.rad + p.width/2
  end

end
