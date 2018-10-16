// Copyright (C) 2018 Don Kelly <karfai@gmail.com>

// This file is part of Interlibr, a functional component of an
// Internet of Rules (IoR).

// ACKNOWLEDGEMENTS
// Funds: Xalgorithms Foundation
// Collaborators: Don Kelly, Joseph Potvin and Bill Olders.

// This program is free software: you can redistribute it and/or
// modify it under the terms of the GNU Affero General Public License
// as published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Affero General Public License for more details.

// You should have received a copy of the GNU Affero General Public
// License along with this program. If not, see
// <http://www.gnu.org/licenses/>.
package controllers

import javax.inject._
import play.api.mvc._
import play.api.libs.json._
import scala.util.{ Success, Failure }

// ours
import org.xalgorithms.storage.bson.BsonJson
import org.xalgorithms.storage.data.{ MongoActions }

// local
import services.InjectableMongo

// FIXME: actor system context
import scala.concurrent.ExecutionContext.Implicits.global

@Singleton
class RulesController @Inject()(
  cc: ControllerComponents,
  mongo: InjectableMongo
) extends AbstractController(cc) {
  import BsonJson.Implicits.val_writes
  import BsonJson.Implicits.doc_writes

  def index = Action.async {
    mongo.find_many(MongoActions.Find("rules")).map { os =>
      Ok(Json.toJson(os))
    }
  }

  def show(id: String) = Action.async { req =>
    mongo.find_one(MongoActions.FindByKey("rules", "public_id", id)).map { o =>
      Ok(Json.toJson(o))
    }
  }
}
